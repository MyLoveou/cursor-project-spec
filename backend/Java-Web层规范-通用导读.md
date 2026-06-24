# Java Web 层规范 · 通用导读（跨项目）

> 来源：B2B WebAPP 开发规范 + Java 开发规范  
> 各项目落地时须做 **架构映射**（如单体 JPA vs webapp 不连库）。

---

## 核心模型

| 名字 | 职责 |
|------|------|
| ReqModel | 前端 → Controller 入参 |
| ResModel | Controller → 前端出参（统一信封包装） |
| Request | Controller → Service 内部请求 |
| BO | Service 内业务对象 |
| VO | RPC/Facade 返回，勿直出前端 |

**口诀**：外面 Model，里面 Request/BO；中间 Converter/Assembler。

---

## 请求链路

```
ReqModel → @Valid → ParamsValidator → Converter(+身份) → Assembler(补全)
→ Service Validator → Client/DAO → BO → ResModel → WebResponse
```

---

## 九条原则（摘要）

1. 字段最小可用  
2. 身份零信任（token，不信前端 userId）  
3. 权限白名单  
4. 水平 + 垂直权限  
5. webapp 无状态（**是否连库因项目而异**）  
6. Controller → Service 单向  
7. 分布式缓存（有 Redis 时）  
8. 单接口 RT 目标  
9. 单一职责 URL  

---

## Java 编码【强制】摘录

- 集合不返 null  
- 包装类 equals；常量放左  
- BigDecimal 金额  
- 不吞异常；子线程 catch + log  
- 写接口幂等  
- 水平权限按资源 id 校验  

---

## 项目落地

在目标项目 `docs/standards/` 编写 **Java/Web 层映射**（ReqModel/BO 与当前栈对照），勿与默认 `Spring-Boot-REST.md` 混用除非已做架构映射。

审查子代理（如 `java-reviewer`）从 ECC 引入后，在 agent 文末追加本项目约束段。

Trilium 等团队知识库中的完整正文不在本库重复。
