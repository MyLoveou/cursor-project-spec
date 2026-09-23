# 项目规范 · Agent（Cursor）

> 本仓库维护 **Cursor** 运行时配置。OpenCode / Hermes 适配已延后。
> 规则在 `rules/`，Agents 在 `agents/`，用 `generate.ps1` 生成 `.cursor/` 格式。
> `shared/` 提供 Skill / Workflow / Eval；`platforms/cursor/` 为 hooks。

| 类型 | 统一源 | 产出 |
|------|--------|------|
| Rules | `rules/{category}/{id}.md` | `.cursor/rules/*.mdc` |
| Agents | `agents/{name}.md` | `.cursor/agents/{name}.md` |
| Skills | `shared/skills/*/SKILL.md` | 部署到 `.cursor/skills/` |
| 工作流 | `shared/workflows/` | `.cursor/workflows/` |
| Hooks | `platforms/cursor/hooks/hooks.json` | `.cursor/hooks/hooks.json` |
| MCP | `mcp/` | `.cursor/mcp.json` + `.cursor/mcp/` |
| 业务域包 | `domains/<id>/` | 合并进 `.cursor/` |

业务项目接入：[BOOTSTRAP.md](./BOOTSTRAP.md)
域包约定：[domains/README.md](./domains/README.md)
结构说明：[STRUCTURE.md](./STRUCTURE.md)

新能力用 `project-spec` Skill（事实基线、决策记忆、**复杂需求先过设计阶段**、切片契约、项目规范、项目架构、门禁）。声称完成前走 `verification-gate`（组合式须测到组合根）。用户反复强调的偏好走 `knowledge-extract`，确认后再写入规则。
