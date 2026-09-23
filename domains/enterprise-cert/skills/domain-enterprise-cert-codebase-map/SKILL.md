---
name: domain-enterprise-cert-codebase-map
description: >-
  企业认证现状摸底。触发：认证代码现状、setting-center 认证梳理、
  大陆香港 API 差异、回填扩展点。强制多轮检索+证据；须人工核实后才能写技术方案。
---

# 企业认证 · 现状摸底

> SDD 阶段 2。本 Skill 自带检索与证据门禁（不再依赖已删除的通用 inventory Skill）。  
> 模板：`domains/enterprise-cert/templates/codebase-map.md`

## 步骤

1. 读知识表（glossary / taboos / business-rules / pending）— 仅「已确认」当约束  
2. **四轮只读检索**（Grep/Glob），每轮留下路径证据；空列写 `未找到（已搜：…）`  
3. 将结果填入域模板（建议 `docs/design/features/<id>-codebase-map.md`）  
4. 打印【摸底自检】；失败则补轮次  
5. 请用户「摸底已核实」；未核实 → **STOP**，不进入 `domain-enterprise-cert-tech-design`

## 本域必做对比轴（写进检索计划）

1. **国家/地区**：大陆 vs 香港（及需求涉及的其他）  
2. **站点**（若多站点）  
3. **渠道**：现有渠道 vs 本需求新渠道  
4. **AB / 拦截 / 回填 / 草稿·快照·智能提示**

## 门禁

- [ ] 模板 §4 接口表：各地区列均有路径或「未找到（已搜）」  
- [ ] 曾漏项检查框已勾或有对抗复核说明  


## 委派

| 需要 | 使用 |
|------|------|
| 主路径追踪 | CodeGraph MCP（若有）→ Task `explore` |
| 工具层说明 | `domain-enterprise-cert-tooling` |
| 不确定业务规则 | `domain-enterprise-cert-knowledge-capture` |
| 搜复用 | 叠加 `search-first` 思路（先 Grep 再言新建） |

## 反模式

- 假设全站/各地区共用同一回填 API  
- 空着香港列当「同大陆」  
- 无人核实就写技术方案  
- 把摸底写成交互实现方案
