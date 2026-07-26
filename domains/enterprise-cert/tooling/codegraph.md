# CodeGraph（代码知识图 MCP）

> 项目：[colbymchenry/codegraph](https://github.com/colbymchenry/codegraph) · 站点：https://codegraph.codes/  
> 作用：本地 SQLite 符号/调用/依赖图；Agent 用 MCP 一次取调用链，少 Grep。  
> **加强**本域 `codebase-inventory` 轮 1–2；**不**替代摸底文档与人核实。

## 安装（业务仓本机）

以官方 CLI 为准（版本会变，安装后执行 `--help`）：

```bash
# 示例：按官网/README 安装 codegraph CLI 后
cd <业务仓根>
codegraph init
# 索引完成后，以 MCP 方式启动（命令以当前版本文档为准）
codegraph serve --mcp
```

将 MCP 配进 Cursor（可参考 `../templates/mcp.json.example` 中 `codegraph` 段）。

## 与摸底 Skill 的约定

当 Cursor 已连接 CodeGraph MCP 时，`codebase-inventory` / `domain-enterprise-cert-codebase-map`：

1. **轮 1**：优先 `codegraph_explore`（或当前版主工具）查入口与调用链，再必要时 `@code-explorer`  
2. **轮 2**：对比轴差分仍可对两侧符号分别 explore；无图命中再 Grep  
3. 证据仍须写入摸底 md（路径/符号）；图谱结果要落到可 CR 文档  
4. 索引过期时以工具提示为准，必要时重建索引后再摸底  

未安装 CodeGraph → 回退 Grep + `@code-explorer`（原流程），不得假装已用图谱。

## 注意

- 100% 本地；勿把索引库当业务真源提交（按 `.gitignore` 忽略 DB，除非团队另有约定）  
- 大仓首次索引耗时；CI 可选，开发机常用即可  
