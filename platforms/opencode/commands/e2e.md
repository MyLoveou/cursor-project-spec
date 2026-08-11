# E2E Command

Run end-to-end tests for critical user flows.

## Instructions

1. Identify critical user journeys to test
2. Use Playwright (preferred) or Agent Browser for test execution
3. Cover happy path, edge cases, and error scenarios
4. Capture screenshots and traces on failure
5. Flag flaky tests for quarantine
6. Upload artifacts and generate test report

Prefer `data-testid` selectors over CSS/XPath. Use proper waits, never `waitForTimeout`.

$ARGUMENTS
