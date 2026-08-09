# ECC Agent Instructions

## Available Agents

### planner
- **Purpose**: Create detailed implementation plans for complex features and refactoring
- **When to Use**: Complex features, refactoring, architectural changes
- **Tools**: Read, Grep, Glob

### architect
- **Purpose**: Software architecture specialist for system design, scalability, and technical decision-making
- **When to Use**: Planning new features, refactoring large systems, making architectural decisions
- **Tools**: Read, Grep, Glob

### product-manager
- **Purpose**: Product requirements analysis, scope definition, acceptance criteria
- **When to Use**: New features, requirement refinement, acceptance criteria decomposition
- **Tools**: Read, Grep, Glob

### code-architect
- **Purpose**: Designs feature architectures by analyzing existing codebase patterns and conventions
- **When to Use**: Feature architecture design, implementation blueprints
- **Tools**: Read, Grep, Glob, Bash

### backend-dev
- **Purpose**: Backend engineer for Spring Boot API, migration, service implementation
- **When to Use**: Modifying backend/, migrations, Spring Boot API changes
- **Tools**: Read, Write, Edit, Bash, Grep, Glob

### frontend-dev
- **Purpose**: Frontend engineer for React pages and components
- **When to Use**: Modifying frontend/, React pages and components
- **Tools**: Read, Write, Edit, Bash, Grep, Glob

### frontend-rn-dev
- **Purpose**: React Native / Expo frontend engineer
- **When to Use**: Modifying app/, screens/, *.native.tsx files
- **Tools**: Read, Write, Edit, Bash, Grep, Glob

### frontend-vue-dev
- **Purpose**: Vue 3 frontend engineer for Vue pages and components
- **When to Use**: Modifying frontend/, Vue pages and components
- **Tools**: Read, Write, Edit, Bash, Grep, Glob

### code-explorer
- **Purpose**: Deeply analyzes existing codebase features by tracing execution paths, mapping architecture layers
- **When to Use**: Understanding existing features before new development
- **Tools**: Read, Grep, Glob

### code-simplifier
- **Purpose**: Simplifies and refines code for clarity, consistency, and maintainability while preserving behavior
- **When to Use**: Code cleanup, readability improvements
- **Tools**: Read, Write, Edit, Bash, Grep, Glob

### code-reviewer
- **Purpose**: Expert code review for quality, security, and maintainability
- **When to Use**: Immediately after writing or modifying code. MUST BE USED for all code changes.
- **Tools**: Read, Grep, Glob, Bash

### react-reviewer
- **Purpose**: Expert React/JSX code reviewer for hook correctness, render performance, server/client boundaries, accessibility
- **When to Use**: Any change touching .tsx/.jsx files or React component logic
- **Tools**: Read, Grep, Glob, Bash

### vue-reviewer
- **Purpose**: Expert Vue 3 code reviewer for Composition API, script setup, Pinia, Vue Router, SFC security
- **When to Use**: Changes touching .vue files or Vue composables
- **Tools**: Read, Grep, Glob, Bash

### java-reviewer
- **Purpose**: Expert Java code reviewer for Spring Boot and Quarkus projects. Auto-detects the framework.
- **When to Use**: All Java code changes
- **Tools**: Read, Grep, Glob, Bash

### typescript-reviewer
- **Purpose**: Expert TypeScript/JavaScript code reviewer for type safety, async correctness, Node/web security, idiomatic patterns
- **When to Use**: All TypeScript and JavaScript code changes
- **Tools**: Read, Grep, Glob, Bash

### security-reviewer
- **Purpose**: Security vulnerability detection and remediation specialist
- **When to Use**: After writing code that handles user input, authentication, API endpoints, or sensitive data
- **Tools**: Read, Write, Edit, Bash, Grep, Glob

### database-reviewer
- **Purpose**: PostgreSQL database specialist for query optimization, schema design, security, and performance
- **When to Use**: Writing SQL, creating migrations, designing schemas, troubleshooting database performance
- **Tools**: Read, Write, Edit, Bash, Grep, Glob

### tdd-guide
- **Purpose**: Test-Driven Development specialist enforcing write-tests-first methodology
- **When to Use**: Writing new features, fixing bugs, or refactoring code
- **Tools**: Read, Write, Edit, Bash, Grep

### e2e-runner
- **Purpose**: End-to-end testing specialist using Vercel Agent Browser (preferred) with Playwright fallback
- **When to Use**: Generating, maintaining, and running E2E tests
- **Tools**: Read, Write, Edit, Bash, Grep, Glob

### qa-engineer
- **Purpose**: QA and quality. Build gates, API smoke tests, DoD verification
- **When to Use**: Verification gates, backend verification, delivery checks
- **Tools**: Read, Bash

### pr-test-analyzer
- **Purpose**: Reviews pull request test coverage quality and completeness with emphasis on behavioral coverage
- **When to Use**: PR test coverage analysis
- **Tools**: Read, Grep, Glob, Bash

### build-error-resolver
- **Purpose**: Build and TypeScript error resolution specialist with minimal diffs
- **When to Use**: Build fails or type errors occur
- **Tools**: Read, Write, Edit, Bash, Grep, Glob

### java-build-resolver
- **Purpose**: Java/Maven/Gradle build, compilation, and dependency error resolution specialist
- **When to Use**: Java builds fail
- **Tools**: Read, Write, Edit, Bash, Grep, Glob

### react-build-resolver
- **Purpose**: Diagnose and fix React build failures across Vite, webpack, Next.js, CRA, Parcel, esbuild, and Bun
- **When to Use**: React build fails
- **Tools**: Read, Write, Edit, Bash, Grep, Glob

### vue-build-resolver
- **Purpose**: Diagnose and fix Vue 3 build failures across Vite, vue-tsc, and Vue SFC compiler
- **When to Use**: Vue frontend build fails
- **Tools**: Read, Write, Edit, Bash, Grep, Glob

### doc-sync
- **Purpose**: Documentation and contract synchronization. Sync docs/design after API/entity changes
- **When to Use**: Modifying Controller/DTO/Entity, syncing documentation
- **Tools**: Read, Write, Edit, Bash, Grep, Glob

### doc-updater
- **Purpose**: Documentation and codemap specialist. Generates codemaps, updates READMEs and guides
- **When to Use**: Updating codemaps and documentation
- **Tools**: Read, Write, Edit, Bash, Grep, Glob

### refactor-cleaner
- **Purpose**: Dead code cleanup and consolidation specialist
- **When to Use**: Removing unused code, duplicates, and refactoring
- **Tools**: Read, Write, Edit, Bash, Grep, Glob

### a11y-architect
- **Purpose**: Accessibility Architect specializing in WCAG 2.2 compliance for Web and Native platforms
- **When to Use**: Designing UI components, establishing design systems, auditing for inclusive user experiences
- **Tools**: Read, Write, Edit, Grep, Glob

### marketing-agent
- **Purpose**: Marketing strategist and copywriter for campaign planning, audience research, positioning, copy creation
- **When to Use**: Product launches, marketing campaigns, copy review
- **Tools**: Read, Grep, Glob, WebSearch, WebFetch

## Agent Groups

### Planning
planner, architect, product-manager, code-architect

### Development
backend-dev, frontend-dev, frontend-rn-dev, frontend-vue-dev, code-explorer, code-simplifier

### Review
code-reviewer, react-reviewer, vue-reviewer, java-reviewer, typescript-reviewer, security-reviewer, database-reviewer

### Testing
tdd-guide, e2e-runner, qa-engineer, pr-test-analyzer

### Operations
build-error-resolver, java-build-resolver, react-build-resolver, vue-build-resolver

### Documentation
doc-sync, doc-updater

### Other
refactor-cleaner, a11y-architect, marketing-agent

## Agent Orchestration

Use agents proactively:
- Complex features -> planner
- Code just written -> code-reviewer
- Bug fix / new feature -> tdd-guide
- Security-sensitive code -> security-reviewer
- Architectural decisions -> architect
- Build failures -> build-error-resolver (or java-build-resolver / react-build-resolver / vue-build-resolver)
- Database changes -> database-reviewer
- E2E testing -> e2e-runner
- React code changed -> react-reviewer
- Vue code changed -> vue-reviewer
- Java code changed -> java-reviewer
- TypeScript code changed -> typescript-reviewer
- Documentation sync -> doc-sync
- Dead code cleanup -> refactor-cleaner
- Accessibility -> a11y-architect
