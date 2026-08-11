# Security Command

Scan for security vulnerabilities in the codebase.

## Instructions

1. Run security audit tools (npm audit, dependency checks)
2. Check OWASP Top 10: injection, broken auth, sensitive data exposure, XSS, CSRF
3. Search for hardcoded secrets, unsafe crypto, dangerous patterns
4. Review auth/authorization on all endpoints
5. Verify input validation at all boundaries
6. Output CRITICAL findings with fix recommendations

If CRITICAL issues found: stop, alert, rotate exposed secrets.

$ARGUMENTS
