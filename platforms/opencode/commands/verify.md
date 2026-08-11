# Verify Command

Run the delivery verification gate before completing work.

## Instructions

1. Run full build: `cd frontend && npm run build` and `.\mvnw.cmd test` (or `mvn test`)
2. If backend changed: restart backend + HTTP smoke test
3. Check documentation sync: API docs, data model, ADRs up to date
4. Run verification-gate skill checklist
5. Confirm no hardcoded secrets, no debug logging, no TODO without tickets
6. Output PASS/FAIL with blocking issues listed first

Do not claim completion until all gates pass.

$ARGUMENTS
