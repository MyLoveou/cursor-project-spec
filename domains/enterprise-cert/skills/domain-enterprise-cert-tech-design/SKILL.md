---
name: domain-enterprise-cert-tech-design
description: >-
  企业认证技术方案（HOW 级）。触发：认证技术方案、SDD 方案、回填校验方案、
  KYB 重拉方案。须含时机/承载/命名/改旧理由；需求穷尽+摸底核实后才可写。
---

# 企业认证 · 技术方案生成

> SDD 阶段 3。模板：`domains/enterprise-cert/templates/tech-design.md`（接入后：`.cursor/domain-packs/enterprise-cert/templates/tech-design.md`）。  
> 对齐根 `plan-workflow` 的确认门禁，但**强制 HOW 章节**（本域踩坑：只写愿望交互、评审看不出实现问题）。

## 前置门禁

- [ ] 需求穷尽完成，疑问表关闭（见 `requirements-gap` / 已定稿需求）
- [ ] `domain-enterprise-cert-codebase-map` 已完成且用户确认「摸底已核实」
- [ ] 已读 `taboos.md`、`glossary.md`、site-diff Rule

任一未满足 → **STOP**。

## 产出

写入：`docs/design/features/<id>-plan.md`（或项目 L3 约定路径），结构必须覆盖模板全部强制节。

状态：`草案` → `评审中` → **`已锁定`**（用户确认后）。

## 强制内容（缺一不可）

| 章节 | 必须写清 |
|------|----------|
| 交互时机 | 如：进页拉 KYB vs 点下一步拉；与草稿/快照关系 |
| 承载形式 | 函数 / hook / 组件 / 配置；放哪一目录 |
| 命名 | 组件、hook、函数、关键参数名 + **业务含义**（可后续补全，但不得空白） |
| 改旧 vs 新增 | 每个关键点：改旧或新增；**不复用须写理由** |
| 站点/国家 | 差异表：行为差在哪、配置键/分支是什么 |
| 渠道与 API | 用哪套 API（分大陆/香港等）；与摸底证据链接 |
| AB | key、默认、未命中行为 |
| 切片 | 可分段交付的纵向切片 + 每片验收点 |
| 禁忌对照 | 如何避免 T1–T8（尤其兜底与曲解） |

## 流程

1. 读已定稿需求 + 已核实摸底
2. 按模板写方案（文字为主；流程图为辅，**不能替代**时机/承载说明）
3. 自检：若评审者只读文字能否判断「进页是否重拉 KYB」「挂旧函数还是新 hook」
4. 请用户评审；确认后状态 → **已锁定**
5. 进入 `domain-enterprise-cert-sdd` 阶段 4 / `implement-feature`

## 反模式

- 只有函数参数传递图、无时机说明
- 只写「要实现怎样的交互」、不写「如何实现」
- 未写改旧/新增决策
- 用「参考现有逻辑」一笔带过且无路径
- 把未确认的业务兜底写进方案
