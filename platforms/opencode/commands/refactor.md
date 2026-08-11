# Refactor Command

Clean up dead code, duplicates, and unused dependencies.

## Instructions

1. Run detection tools (knip, depcheck, ts-prune) in parallel
2. Categorize findings by risk: SAFE → CAREFUL → RISKY
3. Start with SAFE items only: unused exports, unused dependencies
4. Remove one category at a time, run tests after each batch
5. Consolidate duplicate components/utilities
6. Verify build succeeds and tests pass after each batch

NEVER run during active feature development or before production deploys.

$ARGUMENTS
