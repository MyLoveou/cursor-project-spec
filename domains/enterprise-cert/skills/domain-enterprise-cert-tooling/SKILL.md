---
name: domain-enterprise-cert-tooling
description: >-
  企业认证辅助工具层：知识台账、CodeGraph、MCP Knowledge Graph。触发：CodeGraph、
  知识图谱记忆、mcp-knowledge-graph、台账、跨会话记忆、代码图。说明三层分工与接入。
---

# 企业认证 · 工具层（台账 / CodeGraph / MCP KG）

> 详文：`.cursor/domain-packs/enterprise-cert/tooling/`（规范库：`domains/enterprise-cert/tooling/`）。

## 三层分工（必读）

| 层 | 何时用 |
|----|--------|
| **知识台账** | 业务/工程/摸底结论要进 git、可 CR → `ledgers.md` + 对应 Skill |
| **CodeGraph** | 摸底轮 1–2 要调用链/影响面 → `codegraph.md`；接入后 inventory 优先图谱 |
| **MCP Knowledge Graph** | 跨会话想起线索/目标 → `mcp-knowledge-graph.md`；**确认项仍回写台账** |

## 动作

1. 未装 MCP：只做台账 Skills（capture / inventory / conventions）  
2. 已装 CodeGraph：摸底时读 `tooling/codegraph.md` 约定  
3. 已装 mcp-knowledge-graph：开聊可 search；决断后双写（台账为主）  
4. 配置示例：`templates/mcp.json.example` → 合并进项目 Cursor MCP 配置  

## 禁止

- 用 MCP 记忆替代台账「已确认」  
- 未索引 CodeGraph 却声称「图谱已证明各地区 API 相同」  
