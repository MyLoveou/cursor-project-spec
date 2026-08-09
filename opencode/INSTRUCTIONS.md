# OpenCode Instructions

> Multi-platform project configuration. Hard constraints: project `constraints.md`. Coding/security/git baselines in this file.

---

## AI Execution

### Required Reading Index

| Type | Path |
|------|------|
| Overview | `AGENTS.md` |
| Workflows | `shared/workflows/README.md` |
| Hard Constraints | `constraints.md` |
| Workflow Triggers | `shared/skills/workflow-triggers/SKILL.md` |
| Workflow Playbooks | `shared/workflows/` · Skill: `workflow-playbooks` |
| Agent Patterns | `shared/workflows/agent-patterns.md` |

### Sub-Agent Usage

| Scenario | Use |
|----------|-----|
| Explore code | `code-explorer` |
| Java build failure | `java-build-resolver` |
| Frontend build failure | `react-build-resolver` or `vue-build-resolver` |
| After Java changes | `java-reviewer` (recommended) |
| After TSX (Web) changes | `react-reviewer` (recommended) + `react-performance` (hot path) |
| After RN/Expo changes | `frontend-rn-dev` + `react-native-patterns` |
| After .vue changes | `vue-reviewer` (recommended) |
| Security/JWT | `security-reviewer` |
| Database migration | `database-reviewer` |
| Requirements | `product-manager` |
| Market research | `market-research` Skill or `marketing-agent` |
| Deep research (multi-source) | `deep-research` Skill |
| Capability boundaries / PRD | `product-capability` Skill |
| UI design direction | `frontend-design-direction` / `frontend-patterns` |
| Accessibility / Design system | `a11y-architect` · `frontend-a11y` |
| Architecture / ADR | `architect` / `code-architect` · `architecture-decision-records` |
| Complex orchestration | `orch-pipeline` · `plan-orchestrate` |
| Doc sync | `doc-sync` |
| E2E / Browser automation | `agent-browser` Skill · `e2e-runner` |

Full skill list in `workflow-triggers` Skill; when triggered, read the corresponding Skill first.

### Hard Obligation: Restart Backend After Changes

After modifying `backend/**` and before delivery: stop old process → `.\mvnw.cmd spring-boot:run` (or project start command) → migration check → HTTP smoke test.

### DoD Summary

- `verification-gate` Skill (details in Skill body)
- `cd frontend && npm run build`, `.\mvnw.cmd test` (or `mvn test`)
- New capability: `docs/requirements/features/<id>.md` finalized
- Do not commit/push unless user requests

---

## Agent Orchestration

### Available Agents

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| planner | Implementation planning | Complex features, refactoring |
| architect | System design | Architectural decisions |
| tdd-guide | Test-driven development | New features, bug fixes |
| code-reviewer | Code review | After writing code |
| security-reviewer | Security analysis | Before commits |
| build-error-resolver | Fix build errors | When build fails |
| e2e-runner | E2E testing | Critical user flows |
| refactor-cleaner | Dead code cleanup | Code maintenance |
| doc-updater | Documentation | Updating docs |

### Immediate Agent Usage

No user prompt needed:
1. Complex feature requests - Use **planner** agent
2. Code just written/modified - Use **code-reviewer** agent
3. Bug fix or new feature - Use **tdd-guide** agent
4. Architectural decision - Use **architect** agent

### Parallel Task Execution

ALWAYS use parallel execution for independent operations. Launch multiple agents in parallel for independent tasks.

### Multi-Perspective Analysis

For complex problems, use split role sub-agents:
- Factual reviewer
- Senior engineer
- Security expert
- Consistency reviewer
- Redundancy checker

---

## Coding Style

### Immutability (CRITICAL)

ALWAYS create new objects, NEVER mutate existing ones. Immutable data prevents hidden side effects, makes debugging easier, and enables safe concurrency.

### File Organization

MANY SMALL FILES > FEW LARGE FILES:
- High cohesion, low coupling
- 200-400 lines typical, 800 max
- Extract utilities from large modules
- Organize by feature/domain, not by type

### Error Handling

ALWAYS handle errors comprehensively:
- Handle errors explicitly at every level
- Provide user-friendly error messages in UI-facing code
- Log detailed error context on the server side
- Never silently swallow errors

### Input Validation

ALWAYS validate at system boundaries:
- Validate all user input before processing
- Use schema-based validation where available
- Fail fast with clear error messages
- Never trust external data (API responses, user input, file content)

### Code Quality Checklist

Before marking work complete:
- [ ] Code is readable and well-named
- [ ] Functions are small (<50 lines)
- [ ] Files are focused (<800 lines)
- [ ] No deep nesting (>4 levels)
- [ ] Proper error handling
- [ ] No hardcoded values (use constants or config)
- [ ] No mutation (immutable patterns used)

---

## Development Workflow

### Feature Implementation Workflow

1. **Plan First**
   - Use **planner** agent to create implementation plan
   - Identify dependencies and risks
   - Break down into phases

2. **TDD Approach**
   - Use **tdd-guide** agent
   - Write tests first (RED)
   - Implement to pass tests (GREEN)
   - Refactor (IMPROVE)
   - Verify 80%+ coverage

3. **Code Review**
   - Use **code-reviewer** agent immediately after writing code
   - Address CRITICAL and HIGH issues
   - Fix MEDIUM issues when possible

4. **Commit & Push**
   - Detailed commit messages
   - Follow conventional commits format
   - See git workflow section for commit message format and PR process

---

## Code Review

### When to Review

Code review is **mandatory** for:
- After writing or modifying code
- Before any commit to shared branches
- Security-sensitive changes (auth, payments, user data)
- Architectural changes
- Before merging pull requests

Before requesting review, ensure all automated checks pass, merge conflicts are resolved, and the branch is up to date.

### Review Checklist

Before marking code complete:
- [ ] Code is readable and well-named
- [ ] Functions are focused (<50 lines)
- [ ] Files are cohesive (<800 lines)
- [ ] No deep nesting (>4 levels)
- [ ] Errors are handled explicitly
- [ ] No hardcoded secrets or credentials
- [ ] No debug statements
- [ ] Tests exist for new functionality
- [ ] Test coverage meets 80% minimum

### Security Review Triggers

STOP and use **security-reviewer** agent immediately when touching:
- Authentication or authorization code
- User input handling
- Database queries
- File system operations
- External API calls
- Cryptographic operations
- Payment or financial code

### Severity Levels

| Level | Action |
|-------|--------|
| CRITICAL | **BLOCK** — Security or data loss, must fix before merge |
| HIGH | **WARN** — Bug or quality issue, should fix before merge |
| MEDIUM | **INFO** — Maintainability concern |
| LOW | **NOTE** — Style suggestion, optional |

### Review Agents

Use these agents for code review:
| Agent | Purpose |
|-------|---------|
| code-reviewer | General code quality, patterns, best practices |
| security-reviewer | Security vulnerabilities |
| typescript-reviewer | TypeScript/JavaScript specifics |
| java-reviewer | Java/Spring Boot specifics |

---

## Git Workflow

### Commit Message Format

```
<type>: <description>

<optional body>
```

Types: feat, fix, refactor, docs, test, chore, perf, ci

Note: Attribution disabled globally via settings.

### Pull Request Workflow

When creating PRs:
1. Analyze full commit history (not just latest commit)
2. Use `git diff [base-branch]...HEAD` to see all changes
3. Draft comprehensive PR summary
4. Include test plan with TODOs
5. Push with `-u` flag if new branch

---

## Hooks System

### Hook Types

- **PreToolUse**: Before tool execution (validation, parameter modification)
- **PostToolUse**: After tool execution (auto-format, checks)
- **Stop**: When session ends (final verification)

### Auto-Accept Permissions

Use with caution:
- Enable for trusted, well-defined plans
- Disable for exploratory work
- Never use dangerously-skip-permissions flag
- Configure `allowedTools` in settings instead

### Todo Tracking Best Practices

Use todo tracking to:
- Track progress on multi-step tasks
- Verify understanding of instructions
- Enable real-time steering
- Show granular implementation steps

---

## Common Patterns

### Skeleton Projects

When implementing new functionality:
1. Search for battle-tested skeleton projects
2. Use parallel agents to evaluate options:
   - Security assessment
   - Extensibility analysis
   - Relevance scoring
   - Implementation planning
3. Clone best match as foundation
4. Iterate within proven structure

### Design Patterns

#### Repository Pattern

Encapsulate data access behind a consistent interface:
- Define standard operations: findAll, findById, create, update, delete
- Concrete implementations handle storage details (database, API, file, etc.)
- Business logic depends on the abstract interface, not the storage mechanism
- Enables easy swapping of data sources and simplifies testing with mocks

#### API Response Format

Use a consistent envelope for all API responses:
- Include a success/status indicator
- Include the data payload (nullable on error)
- Include an error message field (nullable on success)
- Include metadata for paginated responses (total, page, limit)

---

## Performance Optimization

### Model Selection Strategy

**Haiku 4.5** (90% of Sonnet capability, 3x cost savings):
- Lightweight agents with frequent invocation
- Pair programming and code generation
- Worker agents in multi-agent systems

**Sonnet 4.6** (Best coding model):
- Main development work
- Orchestrating multi-agent workflows
- Complex coding tasks

**Opus 4.6** (Deepest reasoning):
- Complex architectural decisions
- Maximum reasoning requirements
- Research and analysis tasks

### Context Window Management

Avoid last 20% of context window for:
- Large-scale refactoring
- Feature implementation spanning multiple files
- Debugging complex interactions

Lower context sensitivity tasks:
- Single-file edits
- Independent utility creation
- Documentation updates
- Simple bug fixes

### Extended Thinking + Plan Mode

For complex tasks requiring deep reasoning:
1. Ensure extended thinking is enabled (on by default)
2. Enable **Plan Mode** for structured approach
3. Use multiple critique rounds for thorough analysis
4. Use split role sub-agents for diverse perspectives

### Build Troubleshooting

If build fails:
1. Use **build-error-resolver** agent
2. Analyze error messages
3. Fix incrementally
4. Verify after each fix

---

## Security Guidelines

### Mandatory Security Checks

Before ANY commit:
- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user inputs validated
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (sanitized HTML)
- [ ] CSRF protection enabled
- [ ] Authentication/authorization verified
- [ ] Rate limiting on all endpoints
- [ ] Error messages don't leak sensitive data

### Secret Management

- NEVER hardcode secrets in source code
- ALWAYS use environment variables or a secret manager
- Validate that required secrets are present at startup
- Rotate any secrets that may have been exposed

### Security Response Protocol

If security issue found:
1. STOP immediately
2. Use **security-reviewer** agent
3. Fix CRITICAL issues before continuing
4. Rotate any exposed secrets
5. Review entire codebase for similar issues

---

## Testing Requirements

### Minimum Test Coverage: 80%

Test Types (ALL required):
1. **Unit Tests** - Individual functions, utilities, components
2. **Integration Tests** - API endpoints, database operations
3. **E2E Tests** - Critical user flows (framework chosen per language)

### Test-Driven Development

MANDATORY workflow:
1. Write test first (RED)
2. Run test - it should FAIL
3. Write minimal implementation (GREEN)
4. Run test - it should PASS
5. Refactor (IMPROVE)
6. Verify coverage (80%+)

### Troubleshooting Test Failures

1. Use **tdd-guide** agent
2. Check test isolation
3. Verify mocks are correct
4. Fix implementation, not tests (unless tests are wrong)

---

## Documentation Conventions

### Structure

- `requirements/features/` - Single feature requirement packs (multi-round refinement, implementable after finalization)
- `design/` - Architecture, API, data models, `adr/`
- `product/` - Capability boundaries, roadmap

### When to Update

| Change | Update |
|--------|--------|
| New/modified REST | `docs/design/03-API设计.md` |
| New/modified table/entity | `docs/design/02-数据模型.md` + migration |
| New feature requirement | `requirements/features/<id>.md` |
| Architecture decision | `design/adr/NNN-*.md` |
| Delivery scope | `docs/product/capability.md`, `docs/product/roadmap.md` |

### Prohibited

- Bulk rewriting README without request
- Hardcoding mutable test IDs/tokens

---

## Project Core

> Hard constraints: `constraints.md`

### Repository

| Directory | Responsibility |
|-----------|---------------|
| `backend/` | API, persistence |
| `frontend/` | Pages, client |
| `docs/` | Requirements, design, product |

### Invariants (fill per project)

1. (fill per project)
2. (fill per project)

### Prohibited

- Committing secrets, `.env`, local database files
- Coding new capabilities before requirements are finalized (see `requirements-refinement` Skill)
- Using deprecated API paths (maintain project-specific checklist)

### Verification

- backend compile/test; restart backend after changes
- frontend build

---

## Workflow Triggers (Auto)

> **Detailed table sole source**: `shared/skills/workflow-triggers/SKILL.md`
> When maintaining, only modify the Skill; this rule stays minimal to avoid dual-table drift.

On receiving user message, before modifying code, before claiming completion:

1. Read `workflow-triggers` Skill (or scan its trigger table if already loaded)
2. If signal matches → read the corresponding `shared/skills/<name>/SKILL.md` first
3. Before delivery → almost always `verification-gate`

### Quick Entry

| Scenario | Entry |
|----------|-------|
| Unsure | `workflow-triggers` |
| Workflow playbooks | `workflow-playbooks` → `shared/workflows/*.md` |
| Agent patterns | `shared/workflows/agent-patterns.md` |
| New requirement / new API | `scope-check` → `requirements-refinement` (finalize requirements) → `plan-workflow` (finalize plan) |
| Submit requirement, write docs first | `requirements-refinement` |
| Implement (new capability) | `implement-feature` (requires L1+L3 finalized and user confirmed) |
| Fix bug / small change | `implement-feature` (can skip requirement refinement) |
| Delivery / PR | `verification-gate` |

### Pipeline Priority

`scope-check` → `requirements-refinement` (finalize requirements) → `plan-workflow` (finalize plan + user confirmation) → `implement-feature` → `code-review-gate` → Bugbot → `verification-gate`
