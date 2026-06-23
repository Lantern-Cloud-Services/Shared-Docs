# Get-CopilotAICreditUsage.ps1

PowerShell script to retrieve GitHub Copilot AI credit usage from an enterprise.

This script is designed to retrieve usage for users when users are not part of an org, only an enterprise.

## What It Does

- Calls the enterprise billing usage endpoint for AI credits.
- Supports time filters (`year`, `month`, `day`) and optional `user`/`model` filters.
- Can run in:
	- Aggregate mode (single API call, default)
	- Per-user mode (`-PerUser`) by enumerating enterprise Copilot seats and querying each user
- Outputs:
	- JSON to stdout by default
	- CSV or JSON file when `-OutFile` is provided

## Prerequisites

- PowerShell 7+
- GitHub token with enterprise billing read access (for example `manage_billing:copilot` for classic PAT)
- Enterprise slug (URL slug, not display name)

You can pass the token with `-Token`, or set one of these environment variables before running the script:

- `GH_TOKEN`
- `GITHUB_TOKEN`

**Set for the current PowerShell session:**

```powershell
$env:GH_TOKEN = "ghp_yourTokenHere"
```

**Set permanently for your user account (persists across sessions):**

```powershell
[System.Environment]::SetEnvironmentVariable("GH_TOKEN", "ghp_yourTokenHere", "User")
```

**Set via Windows system settings:**

1. Open **Start** → search **"Edit the system environment variables"**
2. Click **Environment Variables…**
3. Under **User variables**, click **New**
4. Set **Variable name** to `GH_TOKEN` and **Variable value** to your token
5. Click **OK**

Once set, you can omit `-Token` from all commands and the script will pick up the variable automatically.

## Basic Usage

Run for the current month (default year/month):

```powershell
.\Get-CopilotAICreditUsage.ps1 -Enterprise my-enterprise -Token $env:GH_TOKEN
```

Run for a specific month:

```powershell
.\Get-CopilotAICreditUsage.ps1 -Enterprise my-enterprise -Year 2026 -Month 5
```

Run in per-user mode:

```powershell
.\Get-CopilotAICreditUsage.ps1 -Enterprise my-enterprise -PerUser
```

Filter to one user and model:

```powershell
.\Get-CopilotAICreditUsage.ps1 -Enterprise my-enterprise -User octocat -Model claude-sonnet-4
```

## Writing Output to a File

Write flattened rows to CSV:

```powershell
.\Get-CopilotAICreditUsage.ps1 -Enterprise my-enterprise -Year 2026 -Month 5 -OutFile usage-2026-05.csv
```

Write raw response to JSON:

```powershell
.\Get-CopilotAICreditUsage.ps1 -Enterprise my-enterprise -Year 2026 -Month 5 -OutFile usage-2026-05.json
```

`-OutFile` supports only `.csv` and `.json`.

## Parameters

- `-Enterprise` (required): Enterprise slug.
- `-Token`: GitHub token. Falls back to `GH_TOKEN`/`GITHUB_TOKEN`.
- `-Year`: 4-digit year.
- `-Month`: Month number (`1-12`).
- `-Day`: Day number (`1-31`).
- `-User`: Filter to one GitHub login.
- `-Model`: Filter to one model name.
- `-PerUser`: Enumerate seats and query usage per user.
- `-OutFile`: Output path (`.csv` or `.json`).
- `-ApiBase`: API base URL (default: `https://api.github.com`).
- `-ApiVersion`: GitHub API version header (default in script: `2026-03-10`).

## API Endpoints Used

| Endpoint | Purpose | When Called |
|----------|---------|-------------|
| `GET /enterprises/{enterprise}/settings/billing/ai_credit/usage` | Retrieves AI credit usage for the enterprise, with optional `year`, `month`, `day`, `user`, and `model` query filters | Every run (aggregate mode) or once per user (per-user mode) |
| `GET /enterprises/{enterprise}/copilot/billing/seats` | Lists all Copilot licensed seats in the enterprise (paginated) | Only when `-PerUser` is specified, to enumerate user logins before querying usage per user |

Reference: [GitHub REST API docs — Billing](https://docs.github.com/en/rest/enterprise-admin/billing)

## Notes

- The script intentionally does not expose an organization filter and is focused on enterprise-level licensing scenarios.
- Data retention for this billing endpoint is limited (see GitHub docs/reference in this repo).
- Per-user mode makes more API calls and can take longer on large enterprises.
