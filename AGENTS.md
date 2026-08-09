# 项目规范 · Agent（多平台）

> 本仓库维护 Cursor / OpenCode / Hermes 三平台的运行时配置。
> 各平台目录**自包含**；`shared/` 提供跨平台共享的 Skill / Workflow / Eval。

| 类型 | 平台 | 规范库路径 | 业务项目路径 |
|------|------|-----------|-------------|
| Rules | Cursor | `cursor/rules/*.mdc` | `.cursor/rules/*.mdc` |
| Rules | OpenCode | `opencode/INSTRUCTIONS.md` | 合并进 `instructions` 数组 |
| Rules | Hermes | `hermes/rules/**/*.md` | `~/.hermes/rules/ecc/` |
| Skills | **共享** | `shared/skills/*/SKILL.md` | `.cursor/skills/` / `skills.paths` / `~/.hermes/skills/` |
| Agents | Cursor | `cursor/agents/*.md` | `.cursor/agents/*.md` |
| Agents | OpenCode | `opencode/agents/*.txt` | `{file:agents/...}` 引用 |
| Agents | Hermes | `hermes/AGENTS.md` | `~/.hermes/AGENTS.md` |
| 工作流 | **共享** | `shared/workflows/` | 各平台对应目录 |
| Hooks | Cursor | `cursor/hooks/hooks.json` | `.cursor/hooks/hooks.json` |
| 业务域包 | 通用 | `domains/<id>/` | 合并进目标平台目录 |

业务项目接入：[BOOTSTRAP.md](./BOOTSTRAP.md)
域包约定：[domains/README.md](./domains/README.md)
结构说明：[STRUCTURE.md](./STRUCTURE.md)
