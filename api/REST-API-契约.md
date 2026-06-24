# REST API 契约（通用）

> 适用于前后端分离 JSON API；项目可扩展 meta 字段与错误码表

---

## 1. 通用约定

| 项 | 约定 |
|----|------|
| 基础路径 | `/api`（或 `/api/v1`） |
| 格式 | JSON，`Content-Type: application/json` |
| 编码 | UTF-8 |
| 时间 | ISO-8601（`2026-06-10T12:00:00Z`） |
| 认证 | `Authorization: Bearer <jwt>`（公开端点除外） |
| 分页 | `?page=0&size=20`（0-based page，团队统一） |

---

## 2. 统一响应信封

### 成功（单对象）

```json
{
  "data": { },
  "meta": { }
}
```

`meta` 可选：版本号、资源 ID、追踪信息等。

### 成功（分页）

```json
{
  "data": [ ],
  "page": {
    "number": 0,
    "size": 20,
    "totalElements": 45,
    "totalPages": 3
  }
}
```

### 错误

```json
{
  "error": {
    "code": "FORBIDDEN",
    "message": "无权访问该资源",
    "details": []
  }
}
```

- 成功响应**不含** `error` 字段
- `details`：校验字段列表等结构化信息

---

## 3. HTTP 状态码

| 状态码 | 含义 | 典型 error.code |
|--------|------|-----------------|
| 200 | 成功 | — |
| 201 | 创建成功 | — |
| 204 | 删除成功（无 body） | — |
| 400 | 参数/校验失败 | `VALIDATION_ERROR` |
| 401 | 未登录 / token 失效 | `UNAUTHORIZED` |
| 403 | 无权限 | `FORBIDDEN` |
| 404 | 资源不存在 | `NOT_FOUND` |
| 409 | 冲突（锁、唯一约束） | `CONFLICT` |
| 501 | 占位未实现 | `NOT_IMPLEMENTED` |

**禁止**：未实现功能返回 200 空数据。

---

## 4. 设计原则

| 原则 | 说明 |
|------|------|
| 薄 Controller | HTTP 层 only |
| DTO 隔离 | 不暴露 ORM Entity |
| 全局异常 | `@RestControllerAdvice` |
| 校验在边界 | `@Valid` on Request DTO |
| 分页列表 | 大结果集必须分页 |
| 日志 | 记录请求（生产加 correlation id） |

---

## 5. RBAC 模板（项目自定义）

在 `docs/design/` 维护角色矩阵，示例：

| role | 读 | 写 | 管理 |
|------|----|----|------|
| ADMIN | ✓ | ✓ | ✓ |
| MEMBER | ✓ | ✓ | — |
| VIEWER | ✓ | — | — |

实现：`SecurityConfig` 路径级 + Service 层资源级校验。

---

## 6. 前后端同步检查单

改 API 时同步：

- [ ] `docs/design/` API 文档
- [ ] 数据模型文档
- [ ] 后端 DTO / Controller
- [ ] 前端 `types/*.ts`
- [ ] 前端 `api/*.ts`
- [ ] 调用方页面/组件

---

## 7. 多域 / 版本（可选）

复杂项目可拆分前缀，例如：

- `/api/admin/**` — 管理
- `/api/public/**` — 匿名可读

或 URI 版本 `/api/v1/**`。在 ADR 中记录选型。

---

## 8. TypeScript 类型示例

```tsx
export interface PageInfo {
  number: number
  size: number
  totalElements: number
  totalPages: number
}

export interface ApiResponse<T> {
  data: T
  meta?: Record<string, unknown>
  page?: PageInfo
}

export interface ApiErrorBody {
  error: {
    code: string
    message: string
    details: unknown[]
  }
}
```
