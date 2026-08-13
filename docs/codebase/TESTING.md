# Testing Patterns

## Core Sections (Required)

### 1) Test Stack and Commands

No test framework is configured. This is a content repository.

Validation is performed by:
- Manual browser review of HTML presentations
- Visual comparison against source/reference slides
- PowerShell script tested manually with live API calls

### 2) Test Layout

N/A — no test files exist in the repository.

### 3) Test Scope Matrix

| Scope | Covered? | Typical target | Notes |
|-------|----------|----------------|-------|
| Unit | No | N/A | No testable application code |
| Integration | No | N/A | PowerShell script tested manually against live GitHub API |
| E2E | No | N/A | HTML decks validated visually in browser |

### 4) Mocking and Isolation Strategy

N/A

### 5) Coverage and Quality Signals

- Coverage tool + threshold: None
- Current reported coverage: N/A
- Known gaps: All validation is manual

### 6) Evidence

- No test configuration files found in scan output
- `.github/copilot-instructions.md` (describes iterative visual review workflow)
