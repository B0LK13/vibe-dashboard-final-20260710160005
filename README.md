# Vibe Dashboard — Project Performance Dashboard

Single-file dashboard (`index.html`, open directly in a browser) showing the health of every
first-party project across C:, D:, E: and F:. Health score = 40% activity recency +
25% commit momentum + 20% repo hygiene + 15% maturity. Click a card to see the "why".

## Files

| File | Purpose |
|---|---|
| `index.html` | The dashboard. Data is embedded in `<script id="scan-data">`, merge metadata in `<script id="scan-meta">`. |
| `scan.ps1` | v2 scanner: collects git telemetry per project into `scan-parts\*.json`. |
| `run-scan.ps1` | One-command refresh: batched scan (`-NoProfile`) + merge. |
| `merge-data.ps1` | Combines part files into `scan-data.json`, snapshots the previous version into `snapshots\`, and injects both data + a merge timestamp into `index.html`. |
| `reflogs\` | Raw reflog exports from the original v1 scan. |

This folder is git-tracked (`origin` on GitHub) — rollback is `git checkout -- <file>` or
`git log` to a prior commit, not `.bak` files (those were removed 2026-07-14; git history is
the rollback mechanism now). `scan-parts\`, `scan-progress.txt`, `scan-done.txt` and `*.bak`
are gitignored — they're regenerated on every run and shouldn't be tracked.

## Refresh the data

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File D:\project-dashboard\vibe-dashboard\run-scan.ps1
```

Resumable: a crashed run continues where it stopped (part files are kept). Full rescan:
delete `scan-parts\` first, or pass `-Force` to `scan.ps1`.

**Important — this only works on the machine being scanned.** `scan.ps1`'s project list
covers paths on `C:\`, `D:\`, `E:\` and `F:\`; it has to run with a real Windows PowerShell +
git against those drives. It cannot be run from a sandboxed/remote environment that only has
this `project-dashboard` folder mounted (that's the situation as of 2026-07-14: the fixes
below were made by reading/editing the scripts, but a real scan still needs to be run locally
to regenerate `scan-data.json` and retire the coverage-patch workaround in `index.html`).

## History / iteration log (autonomous-dev-loop)

- **2026-07-09 (v1)** — dashboard built; scanner hung on its first git call 5×, so hygiene
  fields (`uncommitted`, `fileCount`, `topExtensions`, `hasReadme`) were never collected.
- **2026-07-10 (v2, Claude)** —
  - *Scanner*: every git call now runs with a hard 15s kill-timeout; per-project part files
    make runs crash-safe and resumable; project list expanded 66 → 129 from a full