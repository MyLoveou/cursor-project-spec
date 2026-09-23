# 企业认证域 · 辅助工具层

MCP 只有一套，在规范库 `mcp/`。本目录只保留台账怎么用。

| 层 | 真源 | 说明 |
|----|------|------|
| 知识台账 | 域内 md（knowledge-capture / codebase-map） | 人确认后可评审 |
| CodeGraph | [mcp/codegraph.md](../../../mcp/codegraph.md) | 调用链。默认就在 `mcp.json` |
| 知识图谱 | [mcp/knowledge-graph.md](../../../mcp/knowledge-graph.md) | 可选。不进默认 `mcp.json` |
| 事实与拍板 | `docs/product/facts.md`、`decisions.md` | 跨会话以这两份为准 |

```text
CodeGraph     → 谁调用谁（辅助）
知识图谱      → 聊天线索（可选，不是已确认）
台账 / decisions → 人确认后的记录
```

台账清单：[ledgers.md](./ledgers.md)。
