# Spring Boot REST 开发规范（通用）

> 栈：Java 21+ · Spring Boot 3.x · JPA · Flyway · Spring Security（按需）  
> 参考：ECC springboot-patterns、[BackendBytes REST patterns](https://backendbytes.com/articles/spring-boot-rest-microservice-patterns/)

---

## 1. 分层与数据流

```
db/migration/V{n}__*.sql → entity → repository → service → dto → controller
```

| 层 | 职责 |
|----|------|
| **Controller** | HTTP：状态码、路径、参数绑定；**不写**业务逻辑 |
| **Service** | 业务规则、`@Transactional`、权限二次校验 |
| **Repository** | 数据访问；复杂查询 `@Query` |
| **DTO** | API 入出参；**不**直接暴露 Entity |
| **Entity** | JPA 映射 |
| **exception** | `BusinessException` + `@RestControllerAdvice` |

包结构示例（替换 `{base}` 为项目包名）：

```
{base}/
├── config/
├── controller/
├── service/
├── repository/
├── entity/
├── dto/
├── domain/          # 枚举、值对象
├── security/
└── exception/
```

---

## 2. 命名

| 类型 | 规则 | 示例 |
|------|------|------|
| Entity | PascalCase；表名复数 snake_case | `User` → `users` |
| Repository | `{Entity}Repository` | `UserRepository` |
| Service | `{Domain}Service` 或 `{Area}{Resource}Service` | `OrderService` |
| Controller | `{Area}{Resource}Controller` | `UserController` |
| Request | `{Resource}Request` | `CreateUserRequest` |
| Response | `{Resource}Response` | `UserResponse` |
| Flyway | `V{序号}__{snake描述}.sql` | `V3__add_user_role.sql` |

REST 路径：资源复数、嵌套合理，如 `/api/users/{userId}/orders`。

---

## 3. Entity（JPA）

```java
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String email;

    @Lob
    private String bio;          // 大文本：@Lob + migration CLOB

    @Column(nullable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
```

| 规则 | 说明 |
|------|------|
| 外键 | 可用 `Long xxxId` 简化（团队统一即可） |
| 大字段 | `@Lob` 与 SQL `CLOB` 一致 |
| 时间 | `LocalDateTime`；JSON 用 ISO-8601 |
| 乐观锁 | 高并发写场景可加 `@Version` |

---

## 4. Flyway

| 规则 | 说明 |
|------|------|
| **只增不改** | 禁止修改已执行的 `V{n}__*.sql` |
| 序号递增 | 新脚本 = max(n)+1 |
| 数据修复 | 新 migration，不手改生产/本地库 |
| 改库后 | **重启** Spring Boot，确认日志无 `Migration failed` |

---

## 5. DTO 与校验

```java
public record CreateUserRequest(
        @NotBlank @Email String email,
        @NotBlank @Size(min = 8) String password
) {}
```

```java
@PostMapping
@ResponseStatus(HttpStatus.CREATED)
public ApiResponse<UserResponse> create(@Valid @RequestBody CreateUserRequest request) {
    return ApiResponse.ok(userService.create(request));
}
```

- 优先 **Java record** 作 Request/Response
- JSON 字段 **camelCase**
- 校验失败 → 400 + `VALIDATION_ERROR`（见 [REST-API-契约](../api/REST-API-契约.md)）

---

## 6. 统一响应与异常

成功示例：

```java
return ApiResponse.ok(data);
return ApiResponse.paged(list, ApiResponse.PageInfo.from(page));

@ResponseStatus(HttpStatus.NO_CONTENT)
public void delete(Long id) { ... }
```

全局处理（`@RestControllerAdvice`）：

| 异常 | HTTP | code 示例 |
|------|------|-----------|
| 业务异常 | 4xx/409 等 | 自定义 |
| 资源不存在 | 404 | `NOT_FOUND` |
| 校验失败 | 400 | `VALIDATION_ERROR` |
| 未认证 | 401 | `UNAUTHORIZED` |
| 无权限 | 403 | `FORBIDDEN` |
| 数据冲突 | 409 | `DATA_INTEGRITY_VIOLATION` |

Controller **不要** try-catch 业务异常；Service 抛 `BusinessException` 或领域异常。

---

## 7. 事务

```java
@Transactional(readOnly = true)
public List<UserResponse> list() { ... }

@Transactional
public UserResponse create(CreateUserRequest req) { ... }
```

注意：

- 同类内自调用**不会**走事务代理 → 提取到另一 Bean
- 事务尽量短，避免长 IO

---

## 8. 改后端后必须重启（Spring Boot 惯例）

修改 `backend/**`（Java、Flyway、`application.yml`）后：

1. 停止旧进程（常见端口 8080）
2. `mvnw spring-boot:run`（或 compile 后重启）
3. 冒烟改动接口

**典型坑**：旧进程未重启 → 新 Controller 未加载，PUT 403 空 body。

---

## 9. 反模式

```java
// ❌ Controller 直接操作 Repository
// ❌ 返回 Entity 给前端
// ❌ 手改已执行的 Flyway 脚本
// ❌ 吞掉异常或返回 null 让 Controller 猜 404

// ✅ 薄 Controller + Service + DTO + 全局异常
```

---

## 10. 验收

```powershell
cd backend
.\mvnw.cmd compile    # 或 test
.\mvnw.cmd spring-boot:run   # 改 backend 后
# HTTP 冒烟
```

可选增强（按项目阶段）：OpenAPI、Actuator、结构化日志、MapStruct。
