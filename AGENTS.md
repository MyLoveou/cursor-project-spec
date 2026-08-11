1|# 项目规范 · Agent（多平台）
2|
3|> 本仓库维护 Cursor / OpenCode / Hermes 三平台的运行时配置。
4|> 规则统一在 `rules/`，Agents 统一在 `agents/`，通过 `generate.ps1` 生成各平台格式。
5|> `shared/` 提供跨平台共享的 Skill / Workflow / Eval；`platforms/` 存放平台特有文件。
6|
7|| 类型 | 平台 | 统一源 | 产出（生成） |
8||------|------|--------|-------------|
9|| Rules | 统一源 | `rules/{category}/{id}.md` | — |
10|| Rules | Cursor | ↑ | `.cursor/rules/*.mdc`（保留 frontmatter） |
11|| Rules | OpenCode | ↑ | `opencode/rules/{category}.md`（去 frontmatter） |
12|| Rules | Hermes | ↑ | `~/.hermes/rules/ecc/{category}/{id}.md`（去 frontmatter） |
13|| Agents | 统一源 | `agents/{name}.md` | — |
14|| Agents | Cursor | ↑ | `.cursor/agents/{name}.md`（原样） |
15|| Agents | OpenCode | ↑ | `opencode/agents/{name}.txt`（去 frontmatter） |
16|| Agents | Hermes | ↑ | `~/.hermes/AGENTS.md`（frontmatter → 索引） |
17|| Skills | **共享** | `shared/skills/*/SKILL.md` | 三平台直接可用 |
18|| 工作流 | **共享** | `shared/workflows/` | 各平台对应目录 |
19|| Hooks | Cursor | `platforms/cursor/hooks/hooks.json` | `.cursor/hooks/hooks.json` |
20|| 配置 | OpenCode | `platforms/opencode/opencode.json` | 项目 `opencode.json` |
21|| 命令 | OpenCode | `platforms/opencode/commands/` | `opencode/commands/` |
22|| 业务域包 | 通用 | `domains/<id>/` | 合并进目标平台目录 |
23|
24|业务项目接入：[BOOTSTRAP.md](./BOOTSTRAP.md)
25|域包约定：[domains/README.md](./domains/README.md)
26|结构说明：[STRUCTURE.md](./STRUCTURE.md)
27|
28|## Skills (mandatory)
29|Before replying, scan the skills below. If a skill matches or is even partially relevant to your task, you MUST load it with skill_view(name) and follow its instructions. Err on the side of loading — it is always better to have context you don't need than to miss critical steps, pitfalls, or established workflows. Skills contain specialized knowledge — API endpoints, tool-specific commands, and proven workflows that outperform general-purpose approaches. Load the skill even if you think you could handle the task with basic tools like web_search or terminal. Skills also encode the user's preferred approach, conventions, and quality standards for tasks like code review, planning, and testing — load them even for tasks you already know how to do, because the skill defines how it should be done here.
30|Whenever the user asks you to configure, set up, install, enable, disable, modify, or troubleshoot Hermes Agent itself — its CLI, config, models, providers, tools, skills, voice, gateway, plugins, or any feature — load the `hermes-agent` skill first. It has the actual commands (e.g. `hermes config set …`, `hermes tools`, `hermes setup`) so you don't have to guess or invent workarounds.
31|If a skill has issues, fix it with skill_manage(action='patch').
32|After difficult/iterative tasks, offer to save as a skill. If a skill you loaded was missing steps, had wrong commands, or needed pitfalls you discovered, update it before finishing.
33|