# 变更记录

## 2026-06-19（扁平化）

- **移除 `.cursor/` 包装层**：`rules/`、`skills/`、`agents/` 等提升至规范库根目录
- 业务项目复用时移入 `<项目>/.cursor/`；Bootstrap 脚本已适配
- 删除 `.cursor/README.md`（内容并入 `STRUCTURE.md`）

## 2026-06-19（清理）

- **移除人类可读规范**：删除根目录 `ai/`、`coding/`、`backend/`、`frontend/`、`api/`、`standards/` 及 `.cursor/STANDARDS-LINK.md`
- 约定全部落在 `.cursor/`（rules、skills、workflows、agents）
- Bootstrap 模板迁至仓库根 `templates/`（不再置于 `.cursor/templates/`）
- 修复 `templates/rules/*.mdc.template` 引用，指向 `.cursor/rules/` 而非外部规范目录

## 2026-06-19

### 结构

- 规范库根目录改为 `.cursor/`（符合 Cursor 标准布局）；`rules/*.mdc.template` 置于 `.cursor/rules/`
- 新增 `BOOTSTRAP.md` 作为唯一接入步骤
- `workflow-triggers.mdc` 改为极简 Rule；详表唯一来源为 Skill
- 新增 `backend/README.md`、`frontend/README.md`、`api/README.md`、`ai/README.md`
- 路径占位符 `{SPEC_ROOT}` 替代硬编码绝对路径（模板内）

### 工作流

- 路径触发：新 Controller/migration 须 `requirements-refinement` 已定稿
- 新增 `.cursor/evals/_example-requirements-handoff.md.template`

### 去项目专属引用

- 移除特定业务项目的路径、对照表与 hooks 说明
- 修复 `..cursor` 路径笔误为 `.cursor`
- 目录 `cursor/` 重命名为 `.cursor/`；Rule 模板扁平化到 `.cursor/rules/`

### ECC vendoring（同日）

- `.cursor/agents/`：19 个 ECC agents + 5 个项目角色 agents（运行时 `*.md`）
- `.cursor/rules/`：25 条 ECC rules + 7 条项目 rules（运行时 `*.mdc`）
- `.cursor/evals/`：`_example-feature.md`、`_example-requirements-handoff.md`
- `scripts/sync-ecc-bundle.ps1`：从 `~/.cursor` 刷新 ECC 副本
- 占位符版移至 `.cursor/templates/`；BOOTSTRAP 改为整包复制 `.cursor`

### 产品/设计/Vue（同日）

- vendored Skills：`market-research`、`deep-research`、`product-capability`、`blueprint`、`frontend-design-direction`、`ui-to-vue`、`make-interfaces-feel-better`、`research-ops`
- Agents：`marketing-agent`、`a11y-architect`；Vue：`vue-reviewer`、`vue-build-resolver`、`frontend-vue-dev`
- Rules：`vue-*.mdc`（5 条）、`frontend-vue.mdc`

### 结构（2026-06-19 晚）

- 人类规范合并：`ai/`、`coding/`、`backend/`、`frontend/`、`api/` → **`standards/`**
- 业务项目**只复制** `.cursor/`；新增 `scripts/bootstrap-project.ps1`
- 新增 `.cursor/STANDARDS-LINK.md` 说明链接模式

### 工作流剧本（同日）

- `.cursor/workflows/`：需求、设计、开发、交付四条主流程
- Skill：`workflow-playbooks`；`agent-patterns.md` 对接智能体模式

### 智能体模式（同日）

- `requirements-refinement`、`parallel-execution`、`智能体模式.md`

## 2026-06-12

- 初版从业务项目实践抽离为通用库
