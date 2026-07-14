# flutter

`D:\flutter`

| Field | Value |
|---|---|
| Category | D-root |
| Tech (detected) | — |
| Has git | True |
| Branch | stable |
| Total local commits | 89094 |
| Commits (30d / 90d) | 11 / 53 |
| Uncommitted changes | 0 |
| Contributors | 2237 |
| Tracked files | 15660 |
| Last activity | 2026-06-24 |
| Has README | True |

## Backlog

| ID | Priority | Category | Task |
|---|---|---|---|
| T-0032 | Low | Inventory | Tag as vendor clone, exclude from active tracking |
| T-0033 | Low | Inventory | Confirm still needed at current pin |

### T-0032 — Tag as vendor clone, exclude from active tracking (Low, Inventory)

`flutter` is an upstream vendor clone (89,094 commits, 2,237 contributors) kept for reference/dependency purposes, not an active project of yours. It currently dwarfs every real project's numbers on the dashboard's commit/contributor charts. Add a `vendor: true` tag in `scan.ps1` and filter it out of the dashboard's activity charts and health scoring (see the dashboard's own README "Known limits").

### T-0033 — Confirm still needed at current pin (Low, Inventory)

If this clone exists to support another project (e.g. as a reference or dependency), confirm it's still needed and consider pinning to a specific tag/commit rather than tracking a full moving clone.

---
*Generated from scan-data.json telemetry — commit/file signals only, not a source-code review.*
