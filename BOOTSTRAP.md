# 新项目 Bootstrap

> 规范库根路径 `{SPEC_ROOT}`（克隆本仓库后的绝对路径）。  
> **`.cursor/` 已为运行时整包**（agents、rules、skills、evals、hooks），复制后仅需少量项目专属文件。

---

## 1. 一键复制 `.cursor/`

```powershell
$SPEC = "<规范库根路径>"   # 例：E:\项目\项目规范
$PROJ = "."                 # 目标项目根

Copy-Item -Recurse -Force "$SPEC\.cursor" "$PROJ\.cursor"
```

复制后已包含：

| 目录 | 内容 |
|------|------|
| `skills/` | 工作流 Skill + `workflow-playbooks` |
| `workflows/` | 需求 / 设计 / 开发 / 交付四条主流程剧本 |
| `agents/` | ECC Java/React 栈 agents + 项目角色 agents（`*.md`，可直接 `@`） |
| `rules/` | ECC `common-*` / `java-*` / `react-*` / `typescript-*` + 项目工作流 rules（`*.mdc`） |
| `evals/` | EDD 示例（`_example-*.md`） |
| `hooks/` | `hooks.json` |

**无需**再去掉 `.template` 或从 ECC 重新生成 agents/rules。

## 2. 项目专属文件（必做）

```powershell
Copy-Item "$SPEC\.cursor\constraints.md.template"  "$PROJ\.cursor\constraints.md"
Copy-Item "$SPEC\.cursor\templates\AGENTS.md.template" "$PROJ\AGENTS.md"
```

在 `constraints.md`、`AGENTS.md` 中替换 `{PROJECT}`、`{SPEC_ROOT}` 等占位符。

可选：复制 ECC 能力清单

```powershell
Copy-Item "$SPEC\.cursor\ecc-manifest.md.template" "$PROJ\.cursor\ecc-manifest.md"
```

## 3. 按需微调（非必须）

| 文件 | 何时改 |
|------|--------|
| `.cursor/rules/project-core.mdc` | 填写项目不变量 |
| `.cursor/rules/backend-spring.mdc` | 包名、构建命令 |
| `.cursor/agents/backend-dev.md` 等 | 项目专属约束 |
| `docs/standards/README.md` | 链到 `{SPEC_ROOT}` |

占位符版模板在 `.cursor/templates/`（rules、agents、evals），仅当默认值不适合时参考。

## 4. 文档目录

```powershell
New-Item -ItemType Directory -Force -Path docs/requirements/features
New-Item -ItemType Directory -Force -Path docs/design/adr
New-Item -ItemType Directory -Force -Path docs/product
New-Item -ItemType Directory -Force -Path docs/standards
```

- `docs/standards/README.md` → 链到 `{SPEC_ROOT}/README.md`
- 需求包模板：`{SPEC_ROOT}/.cursor/templates/docs-requirements-feature.md.template`

## 5. 启用 Hooks

Cursor → Hooks → 加载 `.cursor/hooks/hooks.json`

## 6. 校验清单

- [ ] `.cursor/skills/`、`rules/`、`agents/`、`evals/` 齐全
- [ ] `@java-reviewer`、`@product-manager` 等 agents 可被 Cursor 识别
- [ ] `workflow-triggers.mdc` 为极简版；详表在 `skills/workflow-triggers/SKILL.md`
- [ ] `constraints.md`、`AGENTS.md` 占位符已替换
- [ ] `docs/requirements/features/` 已创建

---

## 维护 ECC 内容

本机已安装 ECC 时，在规范库执行：

```powershell
powershell -File scripts/sync-ecc-bundle.ps1
```

从 `~/.cursor/agents/ecc-*.md` 与 `~/.cursor/rules/{common,java,react,typescript}-*.mdc` 刷新 vendored 副本。

维护：新增 Skill → 只改 `.cursor/skills/workflow-triggers/SKILL.md`。
