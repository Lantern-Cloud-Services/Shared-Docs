# Coding Conventions

## Core Sections (Required)

### 1) Naming Rules

| Item | Rule | Example | Evidence |
|------|------|---------|----------|
| HTML decks | snake_case, descriptive, optional version suffix | `GHCP_best_practices_v2.html` | Multiple engagement dirs |
| Prompt files | `prompt.md` or `prompt.txt` (one per engagement) | `engagements/HanoverGHCP_champions/prompt.md` | Convention across engagements |
| Engagement dirs | `<Client>_<topic>` or `<date>_<client>_<topic>` | `HanoverGHCP_champions`, `20260519_trinet_ghcp_metrics` | `engagements/` |
| Assets | Descriptive lowercase, PascalCase for multi-word | `flywheel_box.png`, `ModelSelection.png` | `assets/` folders |
| PowerShell scripts | PascalCase verb-noun | `Get-CopilotAICreditUsage.ps1` | `engagements/AON_Metrics/` |

### 2) Formatting and Linting

- Formatter: None configured
- Linter: None configured
- Enforced rules: None — this is a content repository with no CI pipeline
- Run commands: N/A

### 3) Import and Module Conventions

N/A — no module system. HTML files are fully self-contained (inline `<style>` and `<script>`).

### 4) Error and Logging Conventions

N/A — no runtime code. The PowerShell script uses `Write-Error` / `Write-Warning` and returns structured JSON/CSV output.

### 5) Testing Conventions

N/A — no test framework. Validation is manual browser review of HTML decks.

### 6) Content Authoring Conventions (Repo-Specific)

These are enforced by `.github/copilot-instructions.md`:

| Convention | Rule |
|------------|------|
| Content fidelity | Reproduce source content verbatim; never paraphrase or summarize |
| Color adaptation | Content stays identical; only colors adapt to the deck's theme |
| Image handling | `object-fit: contain` with `max-height`/`max-width`; no clipping |
| Proportional sizing | Match relative size of elements to reference material |
| Iterative workflow | Implement only slides explicitly requested; don't continue beyond |
| Prompt structure | `[VERBATIM]` = exact copy from source; `[NEW]` = author new content |

### 7) Evidence

- `.github/copilot-instructions.md`
- `engagements/HanoverGHCP_champions/prompt.md`
- `engagements/Berkely_ghcp_best_practices/prompt.txt`
