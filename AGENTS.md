# 项目规范 · Agent

> 本仓库维护 Cursor 运行时包（扁平目录），供业务项目复制到 `.cursor/`。

| 类型 | 路径（规范库） | 业务项目 |
|------|----------------|----------|
| 结构说明 | `STRUCTURE.md` | — |
| Rules | `rules/*.mdc` | `.cursor/rules/*.mdc` |
| Skills | `skills/*/SKILL.md` | `.cursor/skills/*/SKILL.md` |
| 工作流 | `workflows/` | `.cursor/workflows/` |
| 业务域包 | `domains/<id>/` | 合并进 `.cursor/`（`-Domain`） |
| DoD | `skills/verification-gate/SKILL.md` | `.cursor/skills/verification-gate/SKILL.md` |

业务项目接入：[BOOTSTRAP.md](./BOOTSTRAP.md)  
域包约定：[domains/README.md](./domains/README.md)
