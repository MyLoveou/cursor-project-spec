# 知识图谱（可选 · 仅企业认证域）

> 包：`@itseasy21/mcp-knowledge-graph`  
> 作用：本机实体/关系，方便下一轮聊天想起线索。  
> **不是**项目事实。已确认内容写 `docs/product/decisions.md` 与企业认证台账 md。

默认 `mcp/mcp.json` **不包含**本服务。只有接入 `enterprise-cert`、且需要跨会话线索时，把下面片段合并进业务仓 `.cursor/mcp.json`，不要覆盖已有的 codegraph / git / ssh。

```json
"mcp-knowledge-graph": {
  "command": "npx",
  "args": ["-y", "@itseasy21/mcp-knowledge-graph"],
  "env": {
    "MEMORY_FILE_PATH": "${workspaceFolder}/.cursor/domain-packs/enterprise-cert/memory/enterprise-cert.jsonl"
  }
}
```

`${workspaceFolder}` 若客户端不支持，改成绝对路径。`memory/*.jsonl` 默认留在本机，不提交。

## 使用

1. 开聊可检索与当前能力相关的节点，当作线索
2. 用户确认的规则：写入台账或 `decisions.md`，再在图里记一条摘要，并带上 md 路径
3. 禁止只写图、不写台账，却在方案里当成已确认

未接入时：只读 facts、decisions 与台账。不要假装查过知识图谱。
