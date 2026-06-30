# Copilot Instructions — Shared-Docs

## Repository Purpose

This is a documentation and presentation knowledge base. It contains `.pptx` source decks, HTML slide presentations, talk tracks, scripts, and reference materials for GitHub Copilot enablement engagements.

## Primary Workflow: HTML Slide Presentations

The main authoring pattern is:

1. A `prompt.txt` file describes the desired deck (slide-by-slide content, layout, talking points).
2. Reference materials (`.pptx` slides, exported images, existing HTML decks) provide visual targets.
3. The output is a self-contained HTML file with slide navigation, dark-mode theming, and responsive layout.

### Rules for Presentation Creation

- **Implement only the slides explicitly requested.** Do not continue to additional slides without being asked. The workflow is iterative — style is dialed in on a few slides before expanding.
- **Reproduce source content verbatim.** Never paraphrase, summarize, or infer content from reference slides. Use the exact titles, descriptions, and bullet points from the source material unless explicitly told to modify them.
- **Match proportional sizing to reference material.** Elements (boxes, images, text blocks) should be roughly the same relative size as in the source slide.
- **Prevent image clipping.** When placing images, use `object-fit: contain` with explicit `max-height` and `max-width` constraints. Always verify that all edges of the image are visible and not truncated by overflow or container bounds.
- **Color scheme follows the deck theme, not the source.** Content stays identical; colors adapt to the HTML presentation's established palette.

## PDF-to-Markdown Conversion

When converting PDF files to Markdown:

- Extract only substantive content (the actual document body).
- Strip page headers, footers, watermarks, URL/navigation bars, and any rendering artifacts from the PDF viewer.
- Preserve the logical structure (headings, lists, code blocks) without adding commentary or restructuring.

## General Principles

- When asked to reproduce or convert content, **fidelity to the source is the default.** Only deviate when explicitly instructed.
- This repo has no build system, linter, or test suite — it is purely content.
