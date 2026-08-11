---
name: workflow-triggers
description: >-
origin: ECC
  工作流路由详表（唯一详表）。触发：规划、构建失败�?03、验收、审查、拆 PR、eval�?
  改项目配置、提需求、新 API、需�?设计/开�?交付工作流�?
---

# 工作流触发路由（详表�?

> **本文件为触发表唯一详表**。机器副本：`rule workflow-triggers`（极简，指向此处）�?

## 使用方式

1. 收到消息或准备改代码前，扫描触发信号
2. 命中 �?**先读**对应 `skill <name>`
3. 多条命中 �?按优先级串联
4. 交付�?�?几乎总是 `verification-gate`

## 工作流剧本（四条主流程）

> **串联 Skill + Agent + Rule 的端到端剧本**：`workflows/`  
> 入口 Skill：`workflow-playbooks`

| 口令 | 剧本 | 文件 |
|------|------|------|
| 需求工作流、提需求、需求定�?| 需�?| `workflows/requirements.md` |
| 设计工作流、UI 设计、设计稿�?Vue | 设计 | `workflows/design.md` |
| 开发工作流、开始实现、修 bug | 开�?| `workflows/development.md` |
| 交付工作流、验收、DoD、准�?PR | 交付 | `workflows/delivery.md` |
| 端到端、从需求到交付 | 顺序执行 | 需�?�?设计（可选）�?开�?�?交付 |

命中「工作流」类口令 �?**先读** `workflow-playbooks` Skill，再打开对应 `workflows/*.md` 按阶段表执行�?

## 用户消息 �?Skill

| 触发信号 | Skill | 优先�?|
|----------|-------|--------|
| 新功能、新 API、纵向切�?| `scope-check` �?`requirements-refinement` �?`plan-workflow` �?`implement-feature` | P0 |
| 提需求、新需求、需求设计、验收标�?| `requirements-refinement` | P0 |
| 市场调研、竞品、TAM、投资者尽�?| `market-research` | P0 |
| 深度调研、多源检索、带引用报告 | `deep-research` | P1 |
| PRD→能力约束、跨服务能力边界 | `product-capability` | P1 |
| 蓝图、多 PR、多会话施工计划 | `blueprint` | P1 |
| UI 方向、更精致、少模板�?| `frontend-design-direction` �?`frontend-design` | P1 |
| UI/UX 设计系统、配色、组件审�?| `ui-ux-pro-max` | P1 |
| 审查 UI、无障碍、Web 界面规范 | `web-design-guidelines` · `frontend-a11y` | P1 |
| React/Next 模式、组件架�?| `frontend-patterns` · `react-performance` | P1 |
| Next.js / Turbopack | `nextjs-turbopack` | P1 |
| React Native / Expo / 移动�?| `react-native-patterns` · `@frontend-rn-dev` | P0 |
| 设计稿转 Vue、批量截图转页面 | `ui-to-vue` | P1 |
| �?bug、改 UI、实�?| `implement-feature` | P0 |
| 规划、计划、蓝�?| `plan-workflow` | P0 |
| 代码现状摸底、inventory、写方案前梳代码、防漏梳 | `codebase-inventory` | P0 |
| 提炼规范、从代码抽约定、项目惯例、coding conventions | `codebase-conventions` | P1 |
| 构建失败、compile、TS error | `build-fix` | P0 |
| 加功�?/ 改功�?/ 修缺�?/ 打磨代码（编排） | `orch-add-feature` / `orch-change-feature` / `orch-fix-defect` / `orch-refine-code` | P1 |
| 从零 MVP | `orch-build-mvp` | P1 |
| ADR、架构决�?| `architecture-decision-records` · `@architect` | P1 |
| 架构审计、六边形架构 | `agent-architecture-audit` · `hexagonal-architecture` | P1 |
| 上线前审�?| `production-audit` | P1 |
| API 设计 / 后端模式 | `api-design` · `backend-patterns` | P1 |
| 构建失败、compile、TS error | `build-fix` | P0 |
| 401�?03、联调、端�?| `local-dev` | P0 |
| 验收、DoD、交付、PR | `verification-gate` | P0 |
| 审查、review | `code-review-gate` | P1 |
| `/review-bugbot`、Bugbot | `code-review-gate` �?`docs/standards/Bugbot审查.md` | P1 |
| `/tdd-workflow`、先写测试、TDD | `docs/standards/TDD与测�?md` · `@tdd-guide` | P0 |
| 浏览器自动化、E2E、截图、填表、爬取、打开网站 | `agent-browser` · `@e2e-runner` | P1 |
| �?PR、分�?| `split-prs` | P1 |
| 加依�?| `search-first` | P1 |
| 查文档、API 参�?| `documentation-lookup` | P2 |
| LLM 成本、配额、token | `cost-aware-llm-pipeline` · `cost-tracking` | P2 |
| 上下文压缩、持续学�?| `strategic-compact` · `continuous-learning-v2` | P2 |
| 自主循环、长任务无人值守 | `autonomous-loops` · `continuous-agent-loop` | P1 |
| eval、pass/fail | `eval-harness` | P1 |
| handoff、跨会话 | `dynamic-workflow-mode` | P1 |
| 并行、加快、多 agent、worktree、lane | `parallel-execution` �?详版 `parallel-execution-optimizer` | P1 |
| 需�?设计/开�?交付工作流、走流程 | `workflow-playbooks` | P0 |
| 智能体模式、委派、并行、Handoff | `workflow-playbooks` �?`workflows/agent-patterns.md` | P1 |
| 企业认证、主体核验、资质审核、营业执照认�?| `domain-enterprise-cert-triggers`（须�?`-Domain enterprise-cert`�?| P0 |
| 企业认证 SDD、认证大需求规范先行、认证技术方�?HOW | `domain-enterprise-cert-sdd` | P0 |
| 认证知识上报、决断入库、沉淀业务规则/交互 | `domain-enterprise-cert-knowledge-capture` | P0 |
| 企业认证工具层、CodeGraph、MCP 知识图谱记忆 | `domain-enterprise-cert-tooling` | P1 |
| �?platform config | `agent-harness-construction` | P1 |

## 路径触发

| 路径 | Skill |
|------|-------|
| 新建 backend Controller、migration�?*新能�?*�?| `scope-check` �?`requirements-refinement`�?*已定�?*）→ `implement-feature` |
| 改已�?Controller（bug/小改，无�?API�?| `implement-feature` |
| Security/JWT 配置 | `code-review-gate` + `@security-reviewer` |
| �?API 设计文档 / DTO | `@doc-sync`；新能力须需求已定稿 |
| �?`docs/requirements/features/**` | `requirements-refinement` |
| �?`docs/product/**`、能力边界讨�?| `product-capability` �?`@product-manager` |
| `frontend/**/*.vue` | `@frontend-vue-dev`；大 UI �?+ `frontend-design-direction` |
| `frontend/**/*.{tsx,jsx}`（Web�?| `@frontend-dev` + `frontend-patterns`；大 UI + `frontend-design-direction` |
| `app/**/*.tsx`、`screens/**`、`*.{native,ios,android}.tsx` | `@frontend-rn-dev` + `react-native-patterns` |
| `docs/design/adr/**` | `architecture-decision-records` |
| `**/enterprise-cert/**`、`**/*EnterpriseCert*` | `domain-enterprise-cert-triggers`（域包已安装时） |
| `{DEPRECATED_API}` 引用 | **STOP** + `scope-check` |
| 平台配置目录 | `agent-harness-construction` |

## 阶段触发

| 阶段 | Skill |
|------|-------|
| 编码开始（新任务） | `scope-check` �?`requirements-refinement`；大任务 + `plan-workflow` + `eval-harness`；多 lane + `parallel-execution` |
| 改完 Java（交付前�?| `@java-reviewer` |
| 改完 Web tsx（交付前�?| `@react-reviewer` + `react-performance`（若热路径） |
| 改完 RN（交付前�?| `@frontend-rn-dev` 自检 + `react-native-patterns`；可�?`@react-reviewer` 辅助 Hooks |
| 改完 .vue（交付前�?| `@vue-reviewer` |
| 上线�?| `production-audit` |
| 声称完成 / stop hook | `verification-gate` |

## 标准组合

```
【端到端新功能】workflow-playbooks
  �?需�?�?设计（可选）�?开�?�?交付

【新需求】scope-check �?requirements-refinement（需求定稿）
  �?plan-workflow（L3 方案定稿 + 用户确认）→ eval-harness
  �?TDD（docs/standards/TDD与测�?md）→ implement-feature
  �?code-review-gate �?/review-bugbot（docs/standards/Bugbot审查.md）→ verification-gate

【新 API】scope-check �?requirements-refinement �?plan-workflow（方案定稿）
  �?eval-harness �?TDD �?implement-feature
  �?reviewers �?code-review-gate �?Bugbot �?verification-gate

【仅修构建】build-fix �?verification-gate

�?03】local-dev �?@code-explorer �?verification-gate

【拆 PR】split-prs �?各仓 verification-gate �?code-review-gate

【复杂大功能】plan-orchestrate �?orch-pipeline / orch-add-feature
  �?parallel-execution-optimizer �?architecture-decision-records（若需�?
  �?implement-feature �?production-audit �?verification-gate

【React Native】scope-check �?�?�?@frontend-rn-dev + react-native-patterns
  �?react-native-* rules �?verification-gate

【Next.js】nextjs-turbopack + frontend-patterns + react-performance
```

## ECC 对照

| ECC | Skill |
|-----|-------|
| `/plan` | `plan-workflow`（须需求已定稿�?|
| 需求沉淀 | `requirements-refinement` |
| `/build-fix` | `build-fix` |
| `/verify` | `verification-gate` + `backend-verify` |
| `/code-review` | `code-review-gate` |
| `/review-bugbot` | `docs/standards/Bugbot审查.md` |
| `/tdd-workflow` | `docs/standards/TDD与测�?md` |
| agent-browser | `agent-browser` |
| orch-* | `orch-pipeline` �?|
| react-native-patterns | 同名 Skill + `react-native-*.mdc` |
| frontend-patterns / react-performance / frontend-a11y | 同名 |
| nextjs-turbopack | 同名 |
| parallel lanes | `parallel-execution` �?`parallel-execution-optimizer` |
| ADR | `architecture-decision-records` |
| 流水线总览 | `docs/standards/工作流索�?md` |
| split-to-prs | `split-prs` |

## 维护

新增 Skill 时：**只改本文�?*。`workflow-triggers.mdc` 保持极简，勿复制整张表�?
