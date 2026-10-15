# External Integrations

## Core Sections (Required)

### 1) Integration Inventory

| System | Type | Purpose | Auth model | Criticality | Evidence |
|--------|------|---------|------------|-------------|----------|
| GitHub Enterprise Billing API | REST API | Retrieve Copilot AI credit usage per enterprise | PAT with `manage_billing:copilot` scope | Medium | `engagements/AON_Metrics/README.md` |
| GitHub Copilot Seats API | REST API | Enumerate enterprise Copilot seat holders | Same PAT | Medium | `engagements/AON_Metrics/Get-CopilotAICreditUsage.ps1` |

### 2) Data Stores

No databases. All content is stored as flat files in the Git repository.

### 3) Secrets and Credentials Handling

- Credential sources: Environment variables (`GH_TOKEN`, `GITHUB_TOKEN`) or `-Token` parameter
- Hardcoding checks: No hardcoded tokens found
- Rotation or lifecycle notes: Standard GitHub PAT expiration policies apply

### 4) Reliability and Failure Behavior

- The PowerShell script handles HTTP errors via standard `Invoke-RestMethod` exception handling
- No retry/backoff logic implemented
- No circuit-breaker pattern

### 5) Observability for Integrations

- Logging: Script outputs warnings/errors to stderr via `Write-Warning`/`Write-Error`
- Metrics/tracing: None
- Missing visibility gaps: No structured logging or telemetry

### 6) Evidence

- `engagements/AON_Metrics/Get-CopilotAICreditUsage.ps1`
- `engagements/AON_Metrics/README.md`
- `engagements/AON_Metrics/COPILOT_AI_CREDIT_API_REFERENCE.md`
