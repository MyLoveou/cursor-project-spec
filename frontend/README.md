# 前端规范导航

> 默认栈：**React + TypeScript + Vite + React Router**，**pages-first** 目录。

## 读哪份文档

| 文档 | 何时读 |
|------|--------|
| [React-TypeScript-目录结构.md](./React-TypeScript-目录结构.md) | **默认**：pages-first、组件目录、导入深度 |
| [React-TypeScript-实践.md](./React-TypeScript-实践.md) | API 客户端、类型、Hooks、路由、反模式 |
| [React-六层规范-通用导读.md](./React-六层规范-通用导读.md) | 六层体系导读；项目落地时映射到上两篇 |
| [../api/REST-API-契约.md](../api/REST-API-契约.md) | 与后端对齐的类型与信封 |

## 与 Agent

- Rule：`.cursor/rules/frontend-react.mdc`
- Skill：`implement-feature`、`build-fix`
- 子代理：`@react-reviewer`、`@react-build-resolver`

## 目录策略

| 策略 | 适用 |
|------|------|
| pages-first（默认） | 路由清晰的中大型 SPA |
| features/（六层 L6） | 无 1:1 路由的功能域、多端复用 |

在项目 Rule 中写明是否用 Redux、CSS Modules 等栈差异。
