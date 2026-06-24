# 后端规范导航

> 默认栈：**Spring Boot 3 + JPA + Flyway** 单体 REST。其他架构须做映射说明。

## 读哪份文档

| 文档 | 何时读 |
|------|--------|
| [Spring-Boot-REST.md](./Spring-Boot-REST.md) | **默认**：分层、Flyway、DTO、异常、事务、验收 |
| [Java-Web层规范-通用导读.md](./Java-Web层规范-通用导读.md) | B2B WebAPP、ReqModel/BO/VO 分层；**非默认栈**时对照映射 |
| [../api/REST-API-契约.md](../api/REST-API-契约.md) | 统一响应信封、状态码、分页 |
| [../coding/安全规范.md](../coding/安全规范.md) | 鉴权、校验、密钥 |

## 与 Agent

- Rule：`.cursor/rules/backend-spring.mdc`
- Skill：`implement-feature`、`backend-verify`、`build-fix`
- 子代理：`@java-reviewer`、`@java-build-resolver`、`@database-reviewer`

## 禁止混用

未在项目 `constraints.md` 声明时，**不要**同时套用 Spring-Boot-REST 与 Java-Web层 ReqModel/BO 两套命名。
