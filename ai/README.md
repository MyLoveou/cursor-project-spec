# AI / Agent 规范导航

> 人类可读原则与流程；**可执行步骤**在 `.cursor/skills/`。

## 文档地图

| 文档 | 用途 |
|------|------|
| [Agent执行规范.md](./Agent执行规范.md) | 角色分工、标准实施流程、DoD 摘要 |
| [智能体模式.md](./智能体模式.md) | 路由、编排、并行、eval、反模式（模式词典） |
| [Cursor项目配置指南.md](./Cursor项目配置指南.md) | Rules / Skills / Agents / Hooks 说明 |
| [验证门禁-DoD.md](./验证门禁-DoD.md) | 交付检查清单 |
| [外部规范参考-ECC.md](./外部规范参考-ECC.md) | ECC 采纳矩阵 |

## 机器配置

| 路径 | 用途 |
|------|------|
| [../.cursor/README.md](../.cursor/README.md) | Skills 索引、生命周期矩阵 |
| [../.cursor/skills/workflow-triggers/SKILL.md](../.cursor/skills/workflow-triggers/SKILL.md) | **工作流触发表（唯一详表）** |
| [../BOOTSTRAP.md](../BOOTSTRAP.md) | 新项目接入步骤 |

## 标准新能力链路

```
scope-check → requirements-refinement（定稿）
  → plan-workflow → implement-feature → verification-gate
```

## SSOT 约定

| 内容 | 唯一详表位置 |
|------|----------------|
| 触发路由 | `workflow-triggers` Skill |
| 需求多轮沉淀 | `requirements-refinement` Skill |
| 交付 DoD 步骤 | `verification-gate` Skill |
| 模式定义 | `智能体模式.md`（链到 Skill，不重复步骤） |
