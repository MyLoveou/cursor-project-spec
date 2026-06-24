# API / 契约规范

> **契约层**：前后端共享的 REST 约定，与具体框架实现解耦。

## 权威文档

| 文档 | 内容 |
|------|------|
| [REST-API-契约.md](./REST-API-契约.md) | 统一信封、HTTP 状态码、分页、RBAC 模板 |

## 与后端 / 前端

- 后端实现细节 → [backend/Spring-Boot-REST.md](../backend/Spring-Boot-REST.md)
- 前端 client/types → [frontend/React-TypeScript-实践.md](../frontend/React-TypeScript-实践.md)
- 项目运行时文档 → `docs/design/03-API设计.md`（每仓库）

## 与 Agent

- Rule：`.cursor/rules/api-contracts.mdc`
- 新能力：需求定稿（`requirements-refinement`）后再改契约
- 同步：`@doc-sync`、改 DTO/Controller 时触发 api-contracts Rule

**原则**：未更新 design 文档就不改对外 API 响应形状。
