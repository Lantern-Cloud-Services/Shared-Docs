# Codebase Concerns

## Core Sections (Required)

### 1) Top Risks (Prioritized)

| Severity | Concern | Evidence | Impact | Suggested action |
|----------|---------|----------|--------|------------------|
| Low | No automated validation of HTML output | No CI/CD pipelines detected | Broken slides discovered only during delivery | Add optional HTML validation or screenshot diffing |
| Low | Engagement content excluded from git tracking by default | `.gitignore` contains `engagements/*` | New engagement work won't be pushed unless force-added | Intentional — keeps client content private; document the override pattern |
| Low | Source-to-output drift | No linkage between `source/` decks and derived outputs | Derived decks may contain stale content after upstream updates | Consider tracking source versions in prompt files |

### 2) Technical Debt

| Debt item | Why it exists | Where | Risk if ignored | Suggested fix |
|-----------|---------------|-------|-----------------|---------------|
| Duplicated HTML decks | Same presentation copied across multiple engagement dirs | `GHCP_best_practices_v2.html` appears 3+ times | Content divergence when one copy is updated | Use symlinks or a canonical `source/` directory with engagement-specific overrides |
| No README beyond one line | Minimal documentation for repo newcomers | `README.md` | Onboarding friction | Expand README with contribution workflow |

### 3) Security Concerns

| Risk | OWASP category | Evidence | Current mitigation | Gap |
|------|----------------|----------|--------------------|-----|
| Token exposure in scripts | A07:2021 (Identification/Auth Failures) | `Get-CopilotAICreditUsage.ps1` accepts `-Token` param | Script docs recommend env vars; no tokens committed | None significant — guidance is present |

### 4) Performance and Scaling Concerns

N/A — static content repository with no runtime performance characteristics.

### 5) Fragile/High-Churn Areas

| Area | Why fragile | Churn signal | Safe change strategy |
|------|-------------|-------------|----------------------|
| `.gitignore` | 3 changes in 90 days | High-churn file list | Review carefully; `engagements/*` exclusion is intentional |
| `GHCP Optimization/advancedContextEngineering_reduced.pptx` | 3 changes in 90 days | Binary file frequently updated | Large binary; consider LFS if it grows further |

### 6) `[ASK USER]` Questions

1. [ASK USER] The `.gitignore` excludes `engagements/*`. Is this intentional to keep client deliverables private, and should new engagement directories be `git add -f`'d explicitly?
2. [ASK USER] Should canonical/master HTML decks (e.g., `GHCP Strategic Enablement/GHCP_strategic_enablement.html`) be considered the single source of truth, with engagement copies treated as frozen snapshots?
3. [ASK USER] Is there a preferred workflow for creating a new engagement directory (naming, folder structure, required files)?

### 7) Evidence

- `.codebase-scan.txt` (high-churn files section)
- `.gitignore`
- `engagements/` directory structure
- `.github/copilot-instructions.md`
