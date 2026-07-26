---
name: domain-enterprise-cert-sdd
description: >-
  企业认证 SDD 分阶段编排。触发：企业认证 SDD、规范先行、认证大需求、中数回填、
  认证技术方案实践、分段实现企业认证。规范先行→摸底→方案锁定→切片实现→变更受控。
---

# 企业认证 · SDD 分阶段编排

> **人主导，AI 执行。** 口诀：规范先行、方案锁定、变更受控、事前穷尽。  
> 域输入：知识表（glossary / taboos / business-rules / ui-interactions）+ pending。  
> 子 Skill：`knowledge-capture`、`codebase-map`、`tech-design`。

## 何时用

- 企业认证大需求（多站点/多国家/AB/新渠道回填等）
- 团队要求按 SDD 实践
- 口令：「企业认证 SDD」「规范先行做认证」「按 SDD 实现回填」

## 阶段总览（必须按序，不可跳）

```text
0 规范加载 → 1 需求穷尽 → 2 现状摸底(人核实)
  → 3 技术方案(人评锁定) → 4 切片实现+分段验收
  → 5 变更受控(如有) → 6 交付/CR缓冲提醒
```

任一阶段未关门禁 → **STOP**，不得进入下一阶段。

---

### 阶段 0 · 规范加载（规范先行）

1. 读本 Skill + 知识表（含 `pending-decisions.md`）
2. 读 Rules：`confirm`（开放发现）、`core`、`site-diff`、`sdd-gates`
3. 确认域包路径（规范库或 `.cursor/domain-packs/enterprise-cert/`）
4. 跑一轮 `domain-enterprise-cert-knowledge-capture` **开放发现**（不限旧 T#/Q#）；有 open 项 →【知识待决断】
5. 大需求建议并行或随后：`codebase-inventory`（阶段 2 必做）、需要时 `codebase-conventions`；会话沉淀可选 `continuous-learning-v2`
6. 输出：已加载清单 + 待决断条数 + 四件套是否已在包内

### 阶段 1 · 需求穷尽（事前穷尽）

**输入**：PRD、Figma、用户补充描述  

**动作**：

1. 用模板 `requirements-gap.md` 整理范围等
2. **必须**用 `domain-enterprise-cert-knowledge-capture` 对 PRD/Figma 做开放发现（业务规则 / 术语 / UI 交互）
3. **STOP**：`pending-decisions` 中影响本需求的 `open` 项未决断则不写方案、不动代码
4. 决断项入库后：需求可定稿；对齐根 `requirements-refinement`

**产出**：`docs/requirements/features/<id>.md`（或项目约定路径）+ 疑问表已关闭

### 阶段 2 · 现状摸底

1. **必须**执行 `domain-enterprise-cert-codebase-map`（内含通用 `codebase-inventory` 四轮）
2. 初稿须含【摸底自检】；对比轴空列禁止当「相同」
3. AI 填写后输出「待人工核实」清单
4. **门禁**：用户明确「摸底已核实」前 → **禁止**写技术方案

### 阶段 3 · 技术方案

1. **必须**执行 `domain-enterprise-cert-tech-design`（HOW 级方案，非仅交互愿望）
2. 默认等待用户/评审：「方案已锁定，可动工」
3. 文档状态：`草案` → `评审中` → **`已锁定`**
4. 未锁定且未明示「直接做」→ **禁止** `implement-feature`

### 阶段 4 · 切片实现与分段验收

1. 按方案中的纵向切片（建议：按模块/站点/功能，忌一次吞全集）
2. 每片：实现 → 对照 `.cursor/domain-packs/enterprise-cert/templates/slice-acceptance.md`（或规范库同名模板）勾选 → 用户或自检通过 → 下一片
3. 反幻觉：未勾选「证据」项不得声称该片完成
4. 反曲解：diff 不得出现「切片外行为变更」（尤其其他分支兜底）
5. 实现时叠加根 `implement-feature`；安全相关加 `@security-reviewer`

### 阶段 5 · 变更受控

若出现：需求追加、摸底疏漏、方案不合理、CR 指出产品不允许：

1. 写 `.cursor/domain-packs/enterprise-cert/templates/change-record.md` 实例（或项目 `docs/design/features/<id>-changes.md`）
2. 评估是否重开阶段 1/2/3
3. **先改方案状态（解锁→修订→再锁定），再改代码**
4. 禁止静默偏航

### 阶段 6 · 交付与 CR 预判

1. 根 `verification-gate` + `code-review-gate`
2. 大改动：在交付摘要中**显式提醒**预留较长 CR 时间（多站点多逻辑）
3. 对照禁忌 T1–T8 做最终扫描

---

## 与根工作流关系

| 本域阶段 | 根 Skill |
|----------|----------|
| 1 需求穷尽 | `scope-check` → `requirements-refinement` |
| 3 方案 | 特化 `domain-enterprise-cert-tech-design`（可对齐 `plan-workflow` 产出路径） |
| 4 实现 | `implement-feature` |
| 6 交付 | `verification-gate` |

## 反模式

- 只让 AI「梳一下代码」无人核实就写方案
- 方案只画函数参数图、不写时机/承载/改旧理由
- 一次会话从需求直通全部编码
- 过度信任 AI 方案/「已完成」
- 业务不确定却先做「合理兜底」
