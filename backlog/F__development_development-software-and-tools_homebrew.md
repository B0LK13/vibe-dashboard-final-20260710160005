# homebrew

`F:\development\development-software-and-tools\homebrew`

| Field | Value |
|---|---|
| Category | development-software-and-tools |
| Tech (detected) | — |
| Has git | True |
| Branch | stable |
| Total local commits | 48963 |
| Commits (30d / 90d) | 0 / 0 |
| Uncommitted changes | 1042 |
| Contributors | 1298 |
| Tracked files | 2810 |
| Last activity | 2026-04-13 |
| Has README | True |

## Backlog

| ID | Priority | Category | Task |
|---|---|---|---|
| T-0209 | Low | Inventory | Tag as vendor clone, exclude from active tracking |
| T-0210 | Low | Inventory | Confirm still needed at current pin |

### T-0209 — Tag as vendor clone, exclude from active tracking (Low, Inventory)

`homebrew` is an upstream vendor clone (48,963 commits, 1,298 contributors) kept for reference/dependency purposes, not an active project of yours. It currently dwarfs every real project's numbers on the dashboard's commit/contributor charts. Add a `vendor: true` tag in `scan.ps1` and filter it out of the dashboard's activity charts and health scoring (see the dashboard's own README "Known limits").

### T-0210 — Confirm still needed at current pin (Low, Inventory)

If this clone exists to support another project (e.g. as a reference or dependency), confirm it's still needed and consider pinning to a specific tag/commit rather than tracking a full moving clone.

---
*Generated from scan-data.json telemetry — commit/file signals only, not a source-code review.*
