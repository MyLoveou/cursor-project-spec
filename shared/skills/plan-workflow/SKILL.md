---
name: plan-workflow
description: >-
  规划、计划、蓝图、怎么拆、实现方案、多 PR 步骤。触发：规划、计划、plan、先别写代码。
origin: ECC /plan（通用版）
---

# 规划工作流（Plan）

> **需求已定稿 → 出 L3 技术方案 → 用户确认 → 再写代码**（除非用户明确「直接做」且承担风险）。

## 前置门禁

- `requirements-refinement` 已完成，且 `docs/requirements/features/<id>.md` 状态为 **已定稿**
- 或：用户明确「直接做」且已记录文档滞后风险
- 未定稿 → **STOP**，回到 `requirements-refinement`

## 产出（硬交付）

须创建或更新 **`docs/design/features/<id>-plan.md`**（模板见 `templates/docs-implementation-plan.md.template`；Bootstrap 可复制到 `docs/standards/`），并满足 `docs/standards/版本与动工门禁.md` §2 L3 checklist。

方案状态：`草案` → `评审中` → **`已定稿`**（**用户确认后**方可 `implement-feature`）。

## 何时触发

- 「规划」「计划」「怎么拆」「蓝图」「技术方案」
- 新能力、多文件/多模块联动
- 任务明显 >1 PR 或 >3 步
- 需求已定稿，准备编码前（**必经**）
- **未**说「直接做」「just do it」

## 流程

### 1. 范围与需求（必做）

读 `scope-check` → 读已定稿需求 → 读 `docs/standards/版本与动工门禁.md` §1（一版本一能力）→ 输出 IN SCOPE / OUT OF SCOPE 与计划对齐检查。

### 2. 现状（只读）

- **大需求 / 多地区多站点**：先跑 `codebase-inventory`（四轮 + 证据门禁），再写本方案
- 小改：Task `explore` 或 `@code-explorer` 可作轻量替代
- 读 `{API_DESIGN_DOC}`、`{DATA_MODEL_DOC}` 相关章节
- 读 UI：`docs/UI/`、`界面规格.md`、Canvas（若有）
- 未「摸底已核实」（若适用）→ **STOP**，勿进入方案定稿

### 3. 方案输出

写入 `docs/design/features/<id>-plan.md`，并附聊天摘要：

```markdown
## 实现计划 · <功能名>

### 目标 / 不交付
### 架构与文件清单（路径级）
### 数据流（主路径 + 错误路径）
### 契约落点（IPC / domain / migration）
### UI（组件、状态、空态/错误态）
### 测试策略
### 风险
### 步骤（纵向切片）
1. …
2. …

### 验收映射（需求 § → 验证方式）
### 验证
- eval：`evals/<feature>.md`（可选）
- 交付：`verification-gate`

### 并行 Lane（大任务可选）
- 读 `parallel-execution`，在计划中附 Lane Matrix
```

### 4. 确认门禁

**默认等待用户确认**「方案已定稿，可动工」后再编码。确认后：

1. 实现方案文档状态 → **已定稿**
2. 进入 `implement-feature`

### 5. 大任务

跨会话 → `dynamic-workflow-mode` + handoff 文件。

明显多 lane（>3 独立步骤）→ 计划中要求 `parallel-execution` Lane Matrix。

## 委派

| 需要 | 使用 |
|------|------|
| 文件级蓝图 | `@code-architect` |
| 架构 | `@architect` |
| 产品边界 | `@product-manager` |

## 反模式

- 需求未定稿就列实现步骤
- 未 scope-check 就列步骤
- 发明未登记 API path
- 计划含 OUT OF SCOPE 能力
- 只在聊天里给计划、不落 `docs/design/features/<id>-plan.md`
- 用户未确认方案就开始写 migration / Vue 组件
