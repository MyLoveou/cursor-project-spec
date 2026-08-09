---
name: implement-feature
description: >-
origin: ECC
  按纵向切片实现功能（后端+前端+迁移+文档）�?
---

# 功能纵向切片（Implement Feature�?

> 标准顺序�?*migration �?后端 �?前端 types/api �?UI �?docs**  
> **硬门�?*：L1 需求已定稿 + L2 契约已登�?+ **L3 技术方案已定稿且用户确�?*（见 `docs/standards/版本与动工门�?md`）�?

## 何时�?

- L3 `docs/design/features/<id>-plan.md` **已定�?* + 用户已确认（或用户「直接做」且已说明风险）
- `scope-check` �?IN SCOPE 后，且非可跳过沉淀的新能力
- �?bug / 小改 UI（可跳过 plan �?requirements-refinement，仍建议 scope-check�?

## 硬门禁（新能力）

开始写业务代码前确认：

- [ ] `docs/requirements/features/<id>.md` 状�?= **已定�?*（L1�?
- [ ] 验收标准已写入需求文�?
- [ ] API/数据变更已在 `docs/design/` 登记（L2，若适用�?
- [ ] `docs/design/features/<id>-plan.md` 状�?= **已定�?*，且用户已确认（L3�?
- [ ] 实现步骤与方案内文件清单一�?

未满�?�?**STOP**；缺 L1/L2 �?`requirements-refinement`；缺 L3 �?`plan-workflow`�?

## 流程

### 1. 读契�?

- `{API_DESIGN_DOC}` 相关 §
- `{DATA_MODEL_DOC}` 若动实体

### 2. 后端（若有）

```
Flyway V{n}__*.sql �?entity �?repository �?service �?dto �?controller
```

- `@Valid` DTO；`GlobalExceptionHandler`
- `{BACKEND_BUILD_CMD}` �?失败�?`build-fix`
- �?backend �?计划内包含重�?冒烟

### 3. 前端（若有）

```
types �?api/*.ts �?pages/components
```

- 前端目录：`rule frontend-react` �?`rule frontend-vue`
- `{FRONTEND_BUILD_CMD}`

### 4. 文档

- 同步 `{API_DESIGN_DOC}` / `{DATA_MODEL_DOC}`

### 5. 收尾

- `@java-reviewer` / `@react-reviewer`（建议）
- `verification-gate`

## 并行决策

默认 **串行** 执行 §2–�?。读 `parallel-execution` 后再并行�?

| 条件 | 允许 |
|------|------|
| 仅仓库探�?/ 读契�?| �?批量只读并行 |
| migration 未完成且前端依赖该表 | �?�?migration + 后端 |
| 契约已在 design 文档锁定 | ⚠️ 后端与前端（mock）可 gated 并行 |
| �?lane 改同一文件 | �?�?ownership |

`plan-workflow` 已附 Lane Matrix 时，�?Matrix 执行；否则不擅自并行写�?

## 原则

- 最�?diff；匹配现有分层与命名
- 不发明未登记 API path
- 未实�?Phase �?501 或占�?UI

## 项目定制

复杂领域（多 API 域、特�?Flyway 编号等）在项目内扩展�?Skill 或增加并�?Skill，并更新 `workflow-triggers`�?
