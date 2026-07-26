# 知识台账（项目真源成长）

> 人决断后落 md，进 git，最稳。MCP 记忆与 CodeGraph **不能**替代本层。

## 台账与 Skill

| 台账 / 产出 | Skill | 内容 |
|-------------|--------|------|
| `glossary.md` / `taboos.md` / `business-rules.md` / `ui-interactions.md` / `pending-decisions.md` | `domain-enterprise-cert-knowledge-capture` | 业务规则、术语、UI |
| `coding-conventions.md` / `conventions-pending.md` | `codebase-conventions` | 工程惯例 |
| `docs/design/features/<id>-codebase-map.md` | `codebase-inventory` + `domain-enterprise-cert-codebase-map` | 摸底结论（须人工核实） |
| `templates/*` 变更单 / 切片验收 | SDD 阶段 4–5 | 变更与验收证据 |

路径（接入后）：`.cursor/domain-packs/enterprise-cert/`（摸底文档可放 `docs/design/features/`）。

## 规则

1. 仅「已确认」行可作为实现依据  
2. 重要会话结论：先决断入库台账，再可选写入 MCP Knowledge Graph  
3. 台账变更可走 CR；勿只存在于聊天或本机 memory 文件  
