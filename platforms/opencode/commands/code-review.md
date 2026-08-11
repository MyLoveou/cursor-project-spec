# Code Review Command

Review code for quality, security, and maintainability.

## Instructions

1. Gather context: check git diff for all changes
2. Review against security checklist (secrets, injection, XSS, auth)
3. Review code quality (large functions, deep nesting, error handling, mutations)
4. Check framework-specific patterns (React hooks, Spring DI, Vue composables)
5. Apply confidence-based filtering (>80% sure before reporting)
6. Output severity-ranked findings with file paths, line numbers, and fix suggestions

End with summary table and verdict: APPROVE / WARNING / BLOCK.

$ARGUMENTS
