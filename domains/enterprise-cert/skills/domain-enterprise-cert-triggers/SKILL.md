---
name: domain-enterprise-cert-triggers
description: >-
  企业认证域触发表。触发：企业认证、主体核验、SDD、知识捕获、代码摸底、工程规范提炼、
  continuous-learning、中数回填、enterprise-cert 路径。
---

# 企业认证 · 域触发路由

> 通用触发表仍以根 `workflow-triggers` 为准。  
> 本 Skill **只**补充本域口令与路径。

## 能力四件套（知识 / 现状 / 工程惯例 / 会话学习）

| Skill | 提炼 / 用途 | 台账或产出 |
|--------|-------------|------------|
| `domain-enterprise-cert-tooling` | 台账 / CodeGraph / MCP Knowledge Graph 三层接入说明 | tooling/* |
| `domain-enterprise-cert-knowledge-capture` | 业务规则、术语、UI 交互 | glossary / taboos / business-rules / ui-interactions / pending |
| `codebase-inventory`（经 `domain-enterprise-cert-codebase-map`） | 功能与 API 现状（可 + CodeGraph） | `*-codebase-map.md` |
| `codebase-conventions` | 代码里的工程惯例 | coding-conventions / conventions-pending |
| `continuous-learning-v2` | 从会话学 instinct（非主动扫库） | homunculus / instincts（需 hooks） |

四者**分台账**，勿混写。

## 大需求 / SDD（优先）

| 触发信号 | 动作 | 优先级 |
|----------|------|--------|
| 企业认证 SDD、规范先行（认证）、认证大需求实践 | **`domain-enterprise-cert-sdd`**（按阶段，勿跳） | P0 |
| 知识上报、决断入库、沉淀规则/术语/交互、认证不确定 | **`domain-enterprise-cert-knowledge-capture`** | P0 |
| CodeGraph、代码图、mcp-knowledge-graph、跨会话记忆、知识台账工具 | **`domain-enterprise-cert-tooling`** | P1 |
| 认证现状摸底、梳理 setting-center 认证、大陆香港 API 差异 | `domain-enterprise-cert-codebase-map`（先 `codebase-inventory`；有 CodeGraph 优先） | P0 |
| 代码现状摸底、inventory、写方案前防漏梳 | `codebase-inventory` | P0 |
| 提炼规范、从代码抽约定、项目惯例、coding conventions | `codebase-conventions` | P1 |
| 持续学习、instinct、会话沉淀、evolve instinct | `continuous-learning-v2` | P2 |
| 认证技术方案、HOW 方案、回填校验方案 | `domain-enterprise-cert-tech-design`（须摸底已核实） | P0 |
| 认证需求穷尽、回填优先级确认、认证疑问表 | `domain-enterprise-cert-sdd` 阶段 1 + `templates/requirements-gap.md` | P0 |

## 口令 → 动作

| 触发信号 | 动作 | 优先级 |
|----------|------|--------|
| 企业认证、主体核验、资质认证、营业执照认证、中数回填 | 读知识表 → 大需求走 SDD；小改走 `implement-feature` | P0 |
| 认证审核、通过/驳回、状态相关 | 有已确认业务规则则遵循；否则 knowledge-capture，勿臆造状态机 | P0 |
| 认证展示、主体资料 | 无已确认规则时先上报，禁止按「通用 KYB」猜测 | P1 |
| 企业认证需求 / 新认证 API | `scope-check` → `requirements-refinement`；大需求再进 SDD | P0 |

## 路径 → 动作

| 路径 | 动作 |
|------|------|
| `**/enterprise-cert/**`、`**/enterprise/**/cert*/**`、`**/*EnterpriseCert*` | 应用 `domain-enterprise-cert-*.mdc`；新能力须需求已定稿 |
| 认证相关 Controller / migration（新状态或新 API） | 大需求：`domain-enterprise-cert-sdd`；否则 scope → 定稿 → implement |
| 认证结果驱动的权限 / 套餐变更 | `code-review-gate` + `@security-reviewer` |

## 事前输入（改代码前）

1. 业务知识表：`glossary` / `taboos` / `business-rules` / `ui-interactions` / `pending-decisions`
2. 工程规范台账（若已跑 conventions）：`coding-conventions.md`
3. Rules：`confirm` / `core` / `site-diff` / `sdd-gates` / `inventory-gate`

## 与通用工作流

- 需求 / 设计 / 开发 / 交付仍走根 `workflows/*`（bundle 内已带）
- 本域大需求用 SDD 编排叠加门禁与模板
- 交付前仍走 `verification-gate`；大改动提醒预留 CR 时间
