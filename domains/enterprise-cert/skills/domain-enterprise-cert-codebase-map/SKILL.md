---
name: domain-enterprise-cert-codebase-map
description: >-
  企业认证现状摸底（委托 codebase-inventory）。触发：认证代码现状、setting-center 认证梳理、
  大陆香港 API 差异、回填扩展点。强制四轮检索+证据；须人工核实后才能写技术方案。
---

# 企业认证 · 现状摸底

> SDD 阶段 2。  
> **先执行通用 Skill `codebase-inventory`（四轮 + 证据门禁）**，再按本域模板补齐章节。  
> 模板：`domains/enterprise-cert/templates/codebase-map.md`  
> （接入后：`.cursor/domain-packs/enterprise-cert/templates/codebase-map.md`）

## 与通用摸底的关系

| 层 | 职责 |
|----|------|
| `codebase-inventory` | 检索计划、四轮流程、证据标准、【摸底自检】、人核实门禁 |
| 本 Skill | 认证域必比维度、曾漏项（跨地区 API）、模板路径 |

**禁止**只读本文件填表而跳过 `codebase-inventory`。

## 本域必做对比轴（轮 0 写进检索计划）

在需求未排除的前提下，至少显式处理：

1. **国家/地区**：大陆 vs 香港（及需求涉及的其他）— API / 字段 / 组件分列证据  
2. **站点**（若多站点）  
3. **渠道**：现有渠道 vs 本需求新渠道（如中数）— 扩展点能否挂载  
4. **AB / 拦截 / 回填 / 草稿·快照·智能提示**（术语以知识表为准；未确认术语先 knowledge-capture）

复盘教训：跨地区调用**不同 API** 却未被梳出 → 轮 2 若一侧无命中必须写 `未找到（已搜：…）`。

## 步骤

1. 读知识表（glossary / taboos / business-rules / pending）— 仅「已确认」当约束  
2. **完整执行 `codebase-inventory`**  
3. 将结果填入域模板（建议路径 `docs/design/features/<id>-codebase-map.md`）  
4. 打印【摸底自检】；失败则补轮次  
5. 请用户「摸底已核实」；未核实 → **STOP**，不进入 `domain-enterprise-cert-tech-design`

## 门禁

同 `codebase-inventory` PASS 条件。域附加：

- [ ] 模板 §4 接口表：各地区列均有路径或「未找到（已搜）」  
- [ ] 曾漏项检查框已勾或有对抗复核说明  

## 委派

| 需要 | 使用 |
|------|------|
| 主路径追踪 | CodeGraph MCP（若有）→ `@code-explorer` / Task `explore` |
| 工具层说明 | `domain-enterprise-cert-tooling` |
| 不确定业务规则 | `domain-enterprise-cert-knowledge-capture` |
| 搜复用 | 叠加 `search-first` 思路（先 Grep 再言新建） |
| 工程隐性规范 | `codebase-conventions`（与业务 knowledge-capture 分台账） |

## 反模式

- 假设全站/各地区共用同一回填 API  
- 空着香港列当「同大陆」  
- 无人核实就写技术方案  
- 把摸底写成交互实现方案
