# 企业认证域 · 辅助工具层

本域在 Skills/台账之外，推荐三层工具，**分工不要混**：

| 层 | 是什么 | 真源落点 | 主要用途 |
|----|--------|----------|----------|
| **知识台账** | md 活文档 + capture/inventory/conventions | **Git 可审**的 `.cursor/domain-packs/enterprise-cert/` 与 `docs/` | 业务规则、工程惯例、摸底结论（人决断后） |
| **CodeGraph** | colbymchenry 本地代码知识图 MCP | 本机 SQLite 索引（不替代台账） | 加强 `codebase-inventory` 轮 1–2 调用链 |
| **MCP Knowledge Graph** | `@itseasy21/mcp-knowledge-graph` 等 | 本机 `memory.jsonl`（建议放项目 `.cursor/` 下） | 跨会话短记忆；**重要结论仍须回写台账** |

```text
CodeGraph          →  结构：谁调用谁（辅助摸底）
MCP Knowledge Graph →  会话：跨聊天记得住（辅助，非 CR 真源）
知识台账 md         →  项目：人确认后的成长（可 PR / 可审计）
```

## 文档

| 文件 | 内容 |
|------|------|
| [ledgers.md](./ledgers.md) | 台账清单与 Skills 映射 |
| [codegraph.md](./codegraph.md) | CodeGraph 安装与摸底用法 |
| [mcp-knowledge-graph.md](./mcp-knowledge-graph.md) | 跨会话记忆 MCP 接入 |
| [../templates/mcp.json.example](../templates/mcp.json.example) | Cursor MCP 配置示例 |

接入业务仓后副本在：`.cursor/domain-packs/enterprise-cert/tooling/`。
