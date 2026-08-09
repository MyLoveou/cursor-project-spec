# Bootstrap 模板（非 Cursor 自动加载）

> 位于规范库根 `templates/`。运行时按平台分布在 `cursor/`、`opencode/`、`hermes/` + `shared/`；Bootstrap 时复制到对应平台目录。

| 模板 | 复制到 |
|------|--------|
| `AGENTS.md.template` | `<项目>/AGENTS.md` |
| `docs-requirements-feature.md.template` | `docs/requirements/features/<id>.md` |
| `docs-standards/*.md.template` | `docs/standards/*.md`（Bootstrap 自动复制） |
| `docs-implementation-plan.md.template` | `docs/design/features/<id>-plan.md`（按需） |
| `agents/*.md.template` | 参考用；运行时见 `agents/*.md` |
| `rules/*.mdc.template` | 参考用；运行时见 `rules/*.mdc` |
| `evals/*.md.template` | 参考用；运行时见 `evals/*.md` |

见 [BOOTSTRAP.md](../BOOTSTRAP.md)、[STRUCTURE.md](../STRUCTURE.md)。
