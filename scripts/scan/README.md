# 规范扫描（Script Scan）

> 确定性规范用脚本扫描，AI 只做裁决。解决"AI 注意力遗漏"问题。

## 用法

```powershell
# 扫描整个项目
powershell -File scripts/scan/scan-assemble.ps1 -Root "E:\项目\YourApp"

# 只看 HIGH 及以上
powershell -File scripts/scan/scan-assemble.ps1 -Root "E:\项目\YourApp" -Severity HIGH

# 输出 JSON（供 AI 裁决）
powershell -File scripts/scan/scan-assemble.ps1 -Root "E:\项目\YourApp" -Json
```

## 组装脚本

`scan-assemble.ps1` 自动发现 `rules/*.ps1` 中的全部扫描器并依次运行，聚合输出 `scan-report.md`。

**新增规范扫描器 = 在 `rules/` 下新增一个 `.ps1`，组装脚本无需修改。**

## 扫描器约定

每个 `rules/*.ps1` 必须：

1. 接受 `-Root <path>` 参数（扫描根目录）
2. 输出违规行，格式：`SEV|rule-id|file:line|message`
3. 严重级：`CRITICAL | HIGH | MEDIUM | LOW | INFO`
4. exit code 返回违规数（0 = 无违规）
5. 文件头注释标注规则源（`规则源: rules/common/xxx.md §节名`）

## 已有扫描器

| 扫描器 | 规则源 | 检测 |
|--------|--------|------|
| `no-console.ps1` | coding-style §调试残留 | console/debugger/TODO |
| `no-implementation-in-pages.ps1` | coding-style §组合根 | 页面文件函数实现 |
| `file-size.ps1` | coding-style §File Organization | 文件行数上限 |

## 规范写入约定

在规则源文件中，可脚本化规范必须标注：

```markdown
## 节名

> `scan: yes` → `scripts/scan/rules/<scanner>.ps1`

规范正文...
```

- `scan: yes` 表示该规范有确定性扫描器
- 扫描器 ID 与规则源节一一对应
- 修改规范时同步修改扫描器

## AI 裁决流程

1. 跑 `scan-assemble.ps1` 得到确定性违规清单
2. 把报告交给 AI：真违规 → 修复；误报 → 加 `scan-ignore` 豁免；规则过严 → 反馈改规则
3. `verification-gate` 门禁前必须跑扫描
