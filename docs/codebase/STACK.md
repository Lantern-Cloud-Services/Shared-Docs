# Technology Stack

## Core Sections (Required)

### 1) Runtime Summary

| Area | Value | Evidence |
|------|-------|----------|
| Primary language | HTML (self-contained slide decks) | `engagements/`, `GHCP Strategic Enablement/` |
| Secondary language | PowerShell 7+ (utility scripts) | `engagements/AON_Metrics/Get-CopilotAICreditUsage.ps1` |
| Tooling language | Python 3.8+ (scan script only) | `.github/skills/acquire-codebase-knowledge/scripts/scan.py` |
| Package manager | None | No manifest files detected |
| Module/build system | None — purely content | `.codebase-scan.txt` |

### 2) Production Frameworks and Dependencies

This is a content-only repository. There are no production frameworks or runtime dependencies.

The HTML presentations are self-contained single-file decks (inline CSS + JS, no build step).

### 3) Development Toolchain

| Tool | Purpose | Evidence |
|------|---------|----------|
| Git | Version control | `.gitignore`, commit history |
| GitHub Copilot | AI-assisted content generation | `.github/copilot-instructions.md` |
| Python 3.8+ | Codebase scan tooling | `.github/skills/acquire-codebase-knowledge/scripts/scan.py` |

### 4) Key Commands

```bash
# No install, build, test, or lint commands — this is a content repository.
# The only executable is the scan script:
python .github/skills/acquire-codebase-knowledge/scripts/scan.py --output docs/codebase/.codebase-scan.txt
```

### 5) Environment and Config

- Config sources: `.github/copilot-instructions.md` (Copilot behavior)
- Required env vars: None for the repo itself. `GH_TOKEN` or `GITHUB_TOKEN` required for the PowerShell usage script.
- Deployment/runtime constraints: None — static content served from GitHub or local file system.

### 6) Evidence

- `.github/copilot-instructions.md`
- `engagements/AON_Metrics/README.md`
- `docs/codebase/.codebase-scan.txt` (scan output)
