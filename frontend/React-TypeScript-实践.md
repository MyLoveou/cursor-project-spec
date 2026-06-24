# React + TypeScript 实践（通用）

> 栈：React 18/19 · TypeScript · Vite · React Router  
> 参考：ECC react-patterns、React TS 2025 社区实践

---

## 1. 命名

| 类型 | 规则 |
|------|------|
| 页面目录 | PascalCase + `Page` 后缀 |
| 组件目录 | PascalCase |
| 导出 | 具名函数 `export function Modal()`，避免默认 export 泛滥 |
| API 模块 | 按域拆分 `api/users.ts` |
| 类型文件 | 按域 `types/user.ts` |
| Store | `*Store.ts` |
| Hook | `use*` |
| CSS 类 | kebab-case |

---

## 2. 类型

- Props：**interface**（可扩展）
- 联合、工具类型：**type**
- 避免 `any`；外部数据用 `unknown` 再窄化
- 避免 `React.FC`（除非有明确理由）
- 公共 API、导出函数：显式参数与返回类型

```tsx
interface ModalProps {
  open: boolean
  onClose: () => void
  children: React.ReactNode
}

export function Modal({ open, onClose, children }: ModalProps) {
  if (!open) return null
  return <div role="dialog">{children}</div>
}
```

域类型与后端 DTO **字段名一致**（camelCase）。

---

## 3. 组件原则

- **渲染即 props + state 的纯函数**（副作用不进 render body）
- **可推导 state 不要用 useEffect 同步**（在 render 中计算）
- 组合优于继承：`children`、组件 props
- 复用逻辑 → `hooks/` 或 `utils/`，非复制粘贴

---

## 4. API 客户端

### 基座 `api/client.ts`

```tsx
export class ApiClientError extends Error {
  constructor(
    readonly status: number,
    readonly code: string,
    message: string,
  ) {
    super(message)
  }
}

export async function requestData<T>(
  path: string,
  options?: RequestInit,
): Promise<T> {
  const res = await fetch(path, {
    headers: { 'Content-Type': 'application/json', ...authHeaders() },
    ...options,
  })
  if (!res.ok) throw await parseError(res)
  if (res.status === 204) return undefined as T
  const envelope = await res.json()
  return envelope.data as T
}
```

| 行为 | 建议 |
|------|------|
| Bearer | 从 auth store 附加 |
| 401 | 清 token，跳转登录（带 redirect） |
| 204 | 返回 undefined |
| 错误 | 抛 `ApiClientError`，页面展示 `message` |

### 域模块

```tsx
const base = (userId: number) => `/api/users/${userId}`

export function listOrders(userId: number): Promise<Order[]> {
  return requestData(`${base(userId)}/orders`)
}
```

- `client.ts`：fetch、错误、认证
- 按域拆分：`auth.ts`、`users.ts`…
- **废弃 API** 单独文件或明确禁止新 import

---

## 5. 路由

- 公开路由 vs `RequireAuth`（或等价守卫）
- 路由参数名与 `App.tsx` **一致**（团队文档写清，避免 `id` vs `userId` 混用）
- 未实现功能：**占位文案**，勿请求不存在 API

---

## 6. 状态

| 层级 | 建议 |
|------|------|
| 局部 UI | `useState` |
| 跨组件同页 | 状态提升或 context |
| 全局（认证等） | store + `useSyncExternalStore` |
| 服务端缓存 | 可选 React Query/SWR（项目统一即可） |

`useSyncExternalStore` 的 **snapshot 必须稳定**。

---

## 7. 错误处理

```tsx
try {
  await api.updateUser(id, body)
} catch (e) {
  if (e instanceof ApiClientError) setError(e.message)
}
```

- 401 尽量在 client 层统一处理
- 列表加载失败显示错误态，勿空白

---

## 8. 反模式

```tsx
// ❌ 用 effect 同步可推导 state
useEffect(() => setTotal(items.reduce(...)), [items])

// ❌ 平铺 components/Foo.tsx
// ❌ 页面私有组件放 components/
// ❌ 继续 import 已废弃 legacy API

// ✅ render 中推导；pages/.../components/；域 api 模块
```

---

## 9. 验收

```powershell
cd frontend
npm run build    # tsc + vite build
```
