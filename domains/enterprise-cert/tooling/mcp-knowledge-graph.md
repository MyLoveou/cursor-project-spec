# MCP Knowledge Graph（跨会话记忆）

> 推荐包：[`@itseasy21/mcp-knowledge-graph`](https://www.npmjs.com/package/@itseasy21/mcp-knowledge-graph)（Anthropic memory 系 fork）  
> 作用：实体 / 关系 / 观察 的本地知识图，跨 Cursor 聊天保留短中期记忆。  
> **重要业务/工程结论仍须写入知识台账 md**（见 [ledgers.md](./ledgers.md)）。

## 与台账的关系

| 存储 | 适合 | 不适合 |
|------|------|--------|
| MCP Knowledge Graph | 会话偏好、进行中目标、临时线索、「上次问过什么」 | 唯一 CR 真源、多人协作规范 |
| 台账 md | 已确认业务规则、摸底、工程惯例 | 高频碎记忆（可先写 MCP 再择要入库） |

```text
会话中发现 → 可选写入 MCP KG（便于下轮想起）
         → 人决断后 → 必须写入台账 md（git）
```

## Cursor 配置

见 `../templates/mcp.json.example`。建议把 `MEMORY_FILE_PATH` 指到业务仓：

```text
<ProjectRoot>/.cursor/domain-packs/enterprise-cert/memory/enterprise-cert.jsonl
```

并将 `memory/` 或该 jsonl **按团队策略**决定是否 gitignore（默认可本机私有；共享结论靠台账）。

### 最小 mcp 片段

```json
{
  "mcpServers": {
    "mcp-knowledge-graph": {
      "command": "npx",
      "args": ["-y", "@itseasy21/mcp-knowledge-graph"],
      "env": {
        "MEMORY_FILE_PATH": "${workspaceFolder}/.cursor/domain-packs/enterprise-cert/memory/enterprise-cert.jsonl"
      }
    }
  }
}
```

`${workspaceFolder}` 若客户端不支持，改成绝对路径。

## Agent 使用约定（本域）

1. 开聊认证大需求时：可用 `search_nodes` / `read_graph` 取与「enterprise-cert / 当前 feature」相关记忆  
2. 用户确认的规则/禁忌：先 `knowledge-capture` 写 md，再 `create_entities` / `add_observations` 镜像摘要（observation 带台账路径）  
3. 禁止：只写 MCP、不写台账，却在方案里当「已确认」  

实体命名建议前缀：`EnterpriseCert_`、`Feature_<id>_`，避免与个人记忆混杂。
