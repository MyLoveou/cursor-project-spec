# Bootstrap

> 从规范库部署运行时配置到业务项目。支持 **Windows / macOS**。
> **自动检测**项目所使用的编辑器平台，一键完成。

## 前置要求

- **Windows**: PowerShell 5.1+（系统自带）
- **macOS**: [PowerShell Core 7+](https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-macos)

## 基本用法

**Windows**:
```powershell
powershell -File scripts/bootstrap-project.ps1 `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp"
```

**macOS**:
```bash
pwsh -File scripts/bootstrap-project.ps1 \
  -SpecRoot "/Users/me/projects/spec-repo" \
  -ProjectRoot "/Users/me/projects/my-app"
```

**可选参数**:
```powershell
-Target all                          # 部署全部平台（默认 auto 自动检测）
-Target cursor|opencode|hermes       # 指定单一平台
-Domain "enterprise-cert"            # 叠加业务域包
```

已有配置时只叠加域包：

**Windows**:
```powershell
powershell -File scripts/apply-domain-pack.ps1 `
  -SpecRoot "E:\项目\项目规范" `
  -ProjectRoot "E:\项目\YourApp" `
  -Target cursor `
  -Domain "enterprise-cert"
```

**macOS**:
```bash
pwsh -File scripts/apply-domain-pack.ps1 \
  -SpecRoot "/Users/me/projects/spec-repo" \
  -ProjectRoot "/Users/me/projects/my-app" \
  -Target cursor \
  -Domain "enterprise-cert"
```

---

## 部署流程

```
bootstrap-project.ps1
    │
    ├─ 1. 自动检测平台（或 -Target 指定）
    │     检测 .cursor/、opencode.json、~/.hermes/config.yaml
    │
    ├─ 2. generate.ps1
    │     rules/*.md + agents/*.md → 平台格式
    │
    ├─ 3. 复制共享资源
    │     shared/skills/、shared/workflows/、shared/evals/
    │
    ├─ 4. 复制平台特有文件
    │     platforms/{cursor|opencode|hermes}/
    │
    └─ 5. 应用域包（可选）
          domains/<id>/ → 合并到目标平台目录
```

---

## 自动检测规则

| 检测信号 | 平台 |
|----------|------|
| `项目/.cursor/` 目录存在 | Cursor |
| `项目/opencode.json` 文件存在 | OpenCode |
| `项目/.hermes/` 或 `~/.hermes/config.yaml` 存在 | Hermes |

未检测到任何平台时，默认使用 Cursor。

---

## 规范库 → 业务项目

### Cursor（`-Target cursor`）

| 规范库 | 业务项目 |
|--------|----------|
| `rules/` + `agents/` → 生成 | `YourApp/.cursor/rules/` + `.cursor/agents/` |
| `platforms/cursor/hooks/` | `YourApp/.cursor/hooks/` |
| `shared/skills/` | `YourApp/.cursor/skills/` |
| `shared/workflows/` | `YourApp/.cursor/workflows/` |
| `shared/evals/` | `YourApp/.cursor/evals/` |
| `domains/<id>/` | 合并进 `.cursor/`（需 `-Domain`） |
| `constraints.md.template` | `YourApp/.cursor/constraints.md` |
| `templates/AGENTS.md.template` | `YourApp/AGENTS.md` |

### OpenCode（`-Target opencode`）

| 规范库 | 业务项目 |
|--------|----------|
| `rules/` + `agents/` → 生成 | `YourApp/opencode/rules/` + `opencode/agents/` |
| `platforms/opencode/opencode.json` | 合并进项目 `opencode.json` |
| `platforms/opencode/agents/build.txt` | `YourApp/opencode/agents/build.txt` |
| `platforms/opencode/commands/` | `YourApp/opencode/commands/` |
| `shared/skills/` | `YourApp/shared/skills/` |
| `shared/workflows/` | `YourApp/shared/workflows/` |

### Hermes（`-Target hermes`）

| 规范库 | 业务项目 |
|--------|----------|
| `rules/` + `agents/` → 生成 | `~/.hermes/rules/ecc/` + `AGENTS.md` |
| `shared/skills/` | `~/.hermes/skills/ecc-imports/` |

> **注意**: Hermes 部署路径为全局 `~/.hermes/`（非项目目录下）。

---

## 跨平台兼容

| 项 | 说明 |
|------|------|
| 路径拼接 | 全部使用 `Join-Path`，不硬编码 `\` 或 `/` |
| 通配符 | `(Join-Path $dir "*")` 替代 `"$dir\*"` |
| 用户目录 | `$env:USERPROFILE`（跨平台） |

## 校验

- [ ] Cursor: Settings → Rules 可见 Project Rules；`@agent-name` 可调用
- [ ] OpenCode: `opencode.json` 中 `instructions`/`agent`/`command` 可正常解析
- [ ] Hermes: 规则和技能在 `~/.hermes/` 下可见
- [ ] 跨平台: macOS 终端中 `pwsh -File scripts/generate.ps1 ...` 正常运行
