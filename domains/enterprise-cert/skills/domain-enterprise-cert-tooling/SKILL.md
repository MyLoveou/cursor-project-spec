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
| **知识台账** | 业务/工程/摸底结论要进 git、可评审 → `ledgers.md` |
| **CodeGraph** | 摸调用链 → 规范库 `mcp/codegraph.md` |
| **知识图谱** | 可选线索 → 规范库 `mcp/knowledge-graph.md`。确认项回写台账或 `decisions.md` |

## 动作

1. 未接 CodeGraph：摸底用检索，并写明未用图谱
2. 已接 CodeGraph：按 `mcp/codegraph.md` 的摸底约定
3. 需要跨会话线索时，按 `mcp/knowledge-graph.md` 合并配置。不把图里的句子当成已确认
4. 不使用 `templates/mcp.json.example` 里的服务器配置（该文件只作指针）

## 禁止

- 用 MCP 记忆替代台账「已确认」  
- 未索引 CodeGraph 却声称「图谱已证明各地区 API 相同」  
