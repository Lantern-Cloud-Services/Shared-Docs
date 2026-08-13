# Codebase Structure

## Core Sections (Required)

### 1) Top-Level Map

| Path | Purpose | Evidence |
|------|---------|----------|
| `.github/` | Copilot instructions, agent primitives, skills | `.github/copilot-instructions.md`, `.github/Agentic Primitives/` |
| `Agentic DevOps/` | PowerPoint source decks on Agentic DevOps topics | `.pptx` files |
| `DevOps Basics/` | PowerPoint source deck on DevOps fundamentals | `.pptx` file |
| `engagements/` | Per-customer engagement deliverables (HTML decks, prompts, scripts) | Multiple subdirectories per client |
| `External Presentations/` | Outward-facing PowerPoint decks | `.pptx` files |
| `FutureDev/` | Future developer experience presentation | `.pptx` file |
| `GHCP Optimization/` | GitHub Copilot optimization presentation | `.pptx` file |
| `GHCP Strategic Enablement/` | Canonical strategic enablement HTML deck + talk track | `GHCP_strategic_enablement.html`, `TALK_TRACK.md` |
| `GitHub Copilot/` | Core GitHub Copilot collateral (KPIs, best practices, usage scripts) | Subdirectories |
| `Platform Engineering/` | Platform engineering PowerPoint decks | `.pptx` files |
| `Rapid Prototyping/` | ChatOps rapid prototyping deck | `.pptx` file |
| `docs/codebase/` | Auto-generated codebase documentation | This file |

### 2) Entry Points

- Main runtime entry: N/A — content repository with no runnable application
- Secondary entry points: `engagements/AON_Metrics/Get-CopilotAICreditUsage.ps1` (standalone PowerShell script)
- How entry is selected: Open `.html` files in a browser; run `.ps1` scripts in PowerShell

### 3) Module Boundaries

| Boundary | What belongs here | What must not be here |
|----------|-------------------|------------------------|
| `engagements/<client>/` | Client-specific deliverables (HTML decks, prompts, assets) | Reusable templates or canonical decks |
| Top-level topic folders | Canonical/master versions of presentations | Client-customized content |
| `.github/` | Copilot configuration, agent definitions, skills | Presentation content |

### 4) Naming and Organization Rules

- **Engagement directories:** `engagements/<ClientName>_<topic>/` or `engagements/<date>_<client>_<topic>/`
- **HTML presentations:** `descriptive_name.html` (snake_case with version suffix)
- **Prompt files:** `prompt.md` or `prompt.txt` — the spec driving HTML generation
- **Assets:** `assets/` subdirectory for images referenced by the deck
- **Source references:** `source/` subdirectory for existing decks used as templates

### 5) Evidence

- Directory tree from `.codebase-scan.txt`
- `.gitignore` (ignores `engagements/*` and temp files)
- `engagements/HanoverGHCP_champions/prompt.md`
