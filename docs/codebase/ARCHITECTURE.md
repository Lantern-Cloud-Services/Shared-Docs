# Architecture

## Core Sections (Required)

### 1) Architectural Style

- Primary style: Content repository — static assets, no runtime architecture
- Why this classification: No build system, no backend, no API. All deliverables are self-contained HTML files or PowerPoint decks.
- Primary constraints: Fidelity to source material; single-file HTML output; iterative Copilot-driven authoring workflow.

### 2) System Flow

```text
prompt.md/prompt.txt → Copilot (AI generation) → Self-contained HTML deck → Browser rendering
                ↗
source/ (reference HTML decks) + assets/ (images)
```

1. Author writes a `prompt.md` or `prompt.txt` specifying slides, layout, and source references.
2. Copilot reads the prompt plus `copilot-instructions.md` rules.
3. Copilot generates/updates a self-contained `.html` file with inline CSS/JS.
4. Author reviews in browser, iterates on specific slides.
5. Final deck is committed to the engagement directory.

### 3) Layer/Module Responsibilities

| Layer or module | Owns | Must not own | Evidence |
|-----------------|------|--------------|----------|
| `prompt.md`/`prompt.txt` | Slide-by-slide specification | Implementation details | `engagements/HanoverGHCP_champions/prompt.md` |
| `.github/copilot-instructions.md` | Global generation rules (fidelity, sizing, color) | Content | `.github/copilot-instructions.md` |
| `source/` | Reference material for verbatim content | Final output | `engagements/HanoverGHCP_champions/source/` |
| `assets/` | Images and sub-components used by decks | Standalone decks | `GHCP Strategic Enablement/assets/` |
| Output `.html` | Complete, browser-renderable presentation | External dependencies | All `*.html` files |

### 4) Reused Patterns

| Pattern | Where found | Why it exists |
|---------|-------------|---------------|
| Design-token dark theme | All HTML decks | Consistent branding across engagements |
| Arrow-key + button slide navigation | All HTML decks | Presentation-mode UX without external tools |
| `[VERBATIM]`/`[NEW]` tagging | `prompt.md` files | Explicit control of content fidelity vs. generation |
| `source/` → `output.html` derivation | `engagements/` subdirectories | Traceability from canonical content to client-specific deck |

### 5) Known Architectural Risks

- **No version linkage between source and output:** If a source HTML deck changes, derived engagement decks may silently drift out of date.
- **No validation or linting:** HTML output correctness depends entirely on manual browser review.

### 6) Evidence

- `engagements/HanoverGHCP_champions/prompt.md`
- `.github/copilot-instructions.md`
- `engagements/Berkely_ghcp_best_practices/prompt.txt`
- `engagements/HanoverGHCP_SandBoxing_SDD/prompt.txt`
