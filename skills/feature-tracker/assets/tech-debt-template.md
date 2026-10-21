# {{PAGE_TITLE}}

{{PAGE_LEDE}} Resolved items stay, marked resolved. Updated {{TODAY}}.

<!-- Entry format, open and resolved:
### Shared initial DB password across tenants

Status: open
Severity: high

Found 2026-05-18. `.env` seeds every tenant with the same initial DB password, a cross-tenant breach risk. Deferred: rotating per-tenant secrets is out of scope for branch `multi-tenancy-1`.

Do later: per-tenant generated secrets before production multi-tenant rollout. Owner: unset.

### resolve_collection duplication in vector-db

Status: resolved 2026-05-29
Severity: low

Found 2026-05-29. Duplicate helper in two route modules. Resolved by consolidating it into `utils.py`.
-->
