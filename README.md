# Vibe Dashboard — Project Performance Dashboard

A single-file, static dashboard that scans every first-party git repo across your local
drives and scores each one on activity, momentum, hygiene, and maturity — so you can see at a
glance which of your ~126 side projects are alive, which are stalling, and which have quietly
gone dormant. No backend, no database: `scan.ps1` walks the filesystem and git history, and
`index.html` renders the result as sortable/filterable cards, a table, and a few charts.

**🔴 Live:** https://b0lk13.github.io/vibe-dashboard-final-20260710160005/

Health score = 40% activity recency + 25% commit momentum + 20% repo hygiene + 15% maturity.
Click a card to see the "why" behind its score.

## Backlog

[`backlog/MASTER_BACKLOG.md`](backlog/MASTER_BACKLOG.md) is a portfolio-wide backlog covering all 126
scanned projects — 290 tasks generated from scan telemetry (git hygiene, dormancy, README presence,
tech-stack recommendations), plus cross-cutting findings (duplicate project names, near-identical
scaffold clusters, vendor clones, stale scan-list entries). Each project also has its own
`backlog/<project-slug>.md` with full detail, and the whole thing is queryable as data in
[`backlog/tasks.json`](backlog/tasks.json). It's telemetry-based, not a source-code review — see the
disclaimer at the top of the master backlog for what that does and doesn't cover.

## Files

| File | Purpose |
|---|---|
| `index.html` | The dashboard. Data is embedded in `<script id="scan-data">`, merge metadata in `<script id="scan-meta">`. |
| `scan.ps1` | v2 scanner: collects git telemetry per project into `scan-parts\*.json`. |
| `run-scan.ps1` | One-command refresh: batched scan (`-NoProfile`) + merge. |
| `merge-data.ps1` | Combines part files into `scan-data.json`, snapshots the previous version into `snapshots\`, and injects both data + a merge timestamp into `index.html`. |
| `backlog\` | Generated backlog: `MASTER_BACKLOG.md`, `tasks.json`, `FINDINGS_AND_RECOMMENDATIONS.md`, one `<project-slug>.md` per scanned project, and `autonomous-loop-runs\` for per-project readiness reports. |
| `commit-backlog.ps1` | Phase-by-phase local committer for the backlog's "uncommitted changes" tasks. |
| `run-autonomous-loop-backlog.ps1` | Phase-by-phase local runner that points `autonomous-loop` at each backlog project for a deeper, code-level readiness pass. |
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

**After changing `scan.ps1` itself, always delete `scan-parts\` (or pass `-Force`) before the
next run.** Per-project part files are skipped if they already exist — re-running without
clearing them just re-merges the *old* output under a new timestamp, silently discarding
whatever the fix was supposed to change (bit us for real on 2026-07-14, see History below).

**Important — this only works on the machine being scanned.** `scan.ps1`'s project list
covers paths on `C:\`, `D:\`, `E:\` and `F:\`; it has to run with a real Windows PowerShell +
git against those drives. It cannot be run from a sandboxed/remote environment that only has
this `project-dashboard` folder mounted.

## History / iteration log (autonomous-dev-loop)

- **2026-07-09 (v1)** — dashboard built; scanner hung on its first git call 5×, so hygiene
  fields (`uncommitted`, `fileCount`, `topExtensions`, `hasReadme`) were never collected.
- **2026-07-10 (v2, Claude)** —
  - *Scanner*: every git call now runs with a hard 15s kill-timeout; per-project part files
    make runs crash-safe and resumable; project list expanded 66 → 129 from a full
    four-drive inventory; batches run `-NoProfile`.
  - *Dashboard*: coverage patch fills filesystem-verified `hasReadme` for the 66 scanned
    projects and adds ~60 missing projects as an honest **Unscanned** state (grey badge,
    no fake health score) until the next scan; dedupe guard prevents double-counting
    after a fresh scan; new "Awaiting scan" stat tile + Unscanned filter/chart slice.
  - *Validation*: embedded JSON untouched by hand; patch applies at runtime; rollback =
    restore `.bak` files.
- **2026-07-14 (cleanup pass, Claude)** — found the entire 2026-07-10 v2 rewrite had been
  sitting uncommitted for 4 days (last real commit was still the v1 "Deploy: final version").
  Fixed while committing that work:
  - `index.html`'s `TODAY` was hardcoded to `'2026-07-10'` — health scores (40% activity
    weight) silently drifted more wrong every day after. Now `new Date()`.
  - `scan.ps1`'s `category` field came out as an empty string for every drive-root project
    (`D:\ai-fintech`, `F:\vibe-dev`, etc.) because `Split-Path` on a drive root has no
    parent leaf. Now falls back to the `<Drive>-root` convention already used in the
    coverage-patch `EXTRAS` list.
  - `run-scan.ps1` hardcoded its batch loop to `135`, disconnected from `scan.ps1`'s real
    126-project list — silent under-scan risk if the list grows without updating both
    numbers in lockstep. Raised to a generous 200 (scan.ps1 clamps past-the-end batches to
    a no-op, so this is cheap headroom, not exact sync).
  - Contributors count was capped at the last 200 commits (`git log -n 200`); switched to
    full-history unique authors.
  - `.bak` files removed (git history is the real rollback mechanism); added `.gitignore`
    for `scan-parts\`, `scan-progress.txt`, `scan-done.txt`.
  - `merge-data.ps1` now snapshots the previous `scan-data.json` into `snapshots\` before
    overwriting, and stamps a merge timestamp into a new `<script id="scan-meta">` block
    that `index.html` reads to build its "last merged" line instead of hand-typed dates.
- **2026-07-14 (real v2 scan + second cleanup pass)** — `run-scan.ps1` finally ran for real
  (all 126 projects, 14 batches, merged at `2026-07-14T10:25:07`). It immediately proved two
  of the same-day code-review fixes wrong/incomplete:
  - The category fix above was **wrong**: `Split-Path -Leaf 'D:\'` returns `'D:\'`, not an
    empty string as assumed, so every drive-root project's category came out as the literal
    string `"D:\\"` instead of `"D-root"`. Re-fixed with a regex match instead of an
    empty-string check, and the already-generated `scan-data.json` + `index.html` were
    patched in place to normalize the bad values rather than requiring a rescan.
  - `[System.IO.Path]::GetExtension()` threw `Illegal characters in path` on `project-llm-wiki`
    (a real repo has some tracked filename it doesn't like), aborting that project's scan
    mid-way and silently dropping `topExtensions`/`lastModified`/`hasReadme` for it (visible
    as an `"error"` field in `scan-data.json`). Replaced with a regex-based extension
    extractor that can't throw; `project-llm-wiki`'s own gap won't self-heal without a rescan.
  - Now that real data covers all 126 projects, the coverage-patch block in `index.html`
    (`README_TRUE`/`README_FALSE`/`EXTRAS`) was confirmed redundant — every `EXTRAS` path
    already exists in the real scan — and deleted.

- **2026-07-14 (redeploy gotcha, Claude)** — a re-run of `run-scan.ps1` right after the fixes
  above silently re-merged the *old* buggy `scan-parts\*.json` files, clobbering the fixed
  `scan-data.json`/`index.html` with the pre-fix category strings and the `project-llm-wiki`
  error again. Root cause: `scan.ps1` skips any project that already has a part file unless
  `-Force` is passed — the part files from the very first buggy run were still sitting in
  `scan-parts\`, so the "fixed" scanner never actually re-ran against them. Restored the
  correct data from git and re-deployed. Added the warning above so this doesn't repeat.

- **2026-07-14 (portfolio backlog, Claude)** — generated `backlog/` from `scan-data.json`
  telemetry: 290 tasks across all 126 projects (git hygiene, dormancy, README gaps, tech-stack
  recommendations, vendor/missing handling), a `MASTER_BACKLOG.md` with cross-cutting findings
  (35 projects with no git at all, 7 duplicate project names across paths, a 16-project
  near-identical scaffold cluster under `development-webpages`, etc.), and a machine-readable
  `tasks.json`. Explicitly telemetry-based — this tool has no file access to the other 125
  repos, so there's no source-code review behind these tasks, only git/filesystem signals.

- **2026-07-14 (scan contamination bug, Claude)** — attempting to act on the backlog's top
  "Critical: commit N pending changes" items surfaced a real scanner bug: `development-agents`,
  `AI-shell`, `sharepoint-automation`, and `mda-cli-v2` — four unrelated projects, not adjacent
  in the project list, split across two different batch runs — all reported byte-identical
  git stats (`branch`, `totalCommits`, `lastCommitDate`, `commits30d`/`90d`, `uncommitted`,
  `contributors`) while their filesystem-derived fields (`fileCount`, `hasReadme`) correctly
  differed. Live investigation found `development-agents` and `mda-cli-v2` have `.git` folders
  that exist but are completely empty (no `HEAD`, no objects, no refs) — so `totalCommits: 10`
  for them was fabricated, not just stale. Root cause not confirmed (suspect
  `Invoke-GitTimeout`'s unawaited `ReadToEndAsync()` under load, or something in how failed/
  timed-out calls fall through) — but two defenses are now in place regardless of cause:
  `scan.ps1` requires `.git\HEAD` to actually exist before trusting `hasGit`, and tracks every
  git fingerprint seen in a run, nulling out and flagging (`suspiciousGitDataReused`) any exact
  repeat instead of silently writing it to the part file; `merge-data.ps1` also warns on any
  duplicate fingerprint across all merged parts, in case an old contaminated part file is still
  sitting in `scan-parts\`. The 4 affected part files were deleted so the next scan (without
  `-Force`, since only theirs are missing) redoes just them with real data. Two of the five
  "Critical" backlog items (`powerplatform-cli-wrapper`, and `sharepoint-automation` once
  rescanned) were confirmed real; the other three were this bug and are not real backlog items.
  Neither could actually be committed from this session, though, for two separate reasons:
  `powerplatform-cli-wrapper` has a stale (or genuinely active — couldn't tell from here)
  `.git\index.lock`; `sharepoint-automation`'s root-level files weren't reachable through the
  session's folder mount at all (directories listed fine, individual files like `README.md`
  came back "does not exist"). Added `commit-backlog.ps1` to do this locally instead, phase by
  phase, with a stale-lock safety check.

- **2026-07-14 (findings report + autonomous-loop integration, Claude)** — wrote
  `backlog/FINDINGS_AND_RECOMMENDATIONS.md`, synthesizing everything above into a prioritized
  "do first / do next / do when there's time" list, plus a live proof-of-concept run of
  `D:\autonomous-loop` (a separate tool already in the portfolio) against `vibe-dashboard`
  itself: analysis-only, no changes made, real result of **0.537 — BLOCKED** (no automated
  tests, 5 missing MVP elements) — report under `backlog/autonomous-loop-runs/vibe-dashboard/`.
  Added `run-autonomous-loop-backlog.ps1`, mirroring `commit-backlog.ps1`'s phase-by-priority
  pattern, so the same readiness pass can be run locally across the rest of the backlog
  (defaults to `-Strategy analysis-only`; `-Strategy full` applies small, git-checkpointed,
  auto-reverting improvements once you're ready to trust it further). This session's own file
  access is too limited to run it against most of the 126 projects directly (see the
  `sharepoint-automation` note above) — this is a local-execution tool by design, same as
  `commit-backlog.ps1`.

## Known limits / next iteration

- `project-llm-wiki`'s 2026-07-14 scan entry is missing `topExtensions`/`lastModified`/
  `hasReadme` (see the `GetExtension` crash above, now fixed for next time) — needs a rescan
  to backfill, `-Force` on just that project or a full rerun.
- Vendor clones (`flutter`: 89k commits/2237 contributors, `homebrew`: 49k commits/1298
  contributors) are kept for continuity and clearly dwarf every real project's numbers on
  the commits/contributors charts; consider a `vendor` tag to exclude them from those views.
- `snapshots\` will grow unbounded over time; add pruning (e.g. keep last N) once there's
  enough history to make trend charts worth building.
- Take the lesson from the category bug: don't trust an assumption about `Split-Path`
  (or any PowerShell cmdlet) edge-case behavior without testing it against a real drive-root
  path — code review alone missed it, a real run caught it immediately.
- `backlog/` is a point-in-time snapshot generated from one scan — it doesn't auto-regenerate
  on `run-scan.ps1`. Re-run the generator script after future rescans if you want the backlog
  to reflect fresh telemetry (script isn't wired into the refresh pipeline yet).
- `development-agents`, `AI-shell`, `sharepoint-automation`, `mda-cli-v2` need a plain rescan
  (`run-scan.ps1`, no `-Force` needed — only their 4 part files were deleted) to get real data
  after the scan-contamination bug above; until then they're simply missing from `scan-data.json`
  rather than wrong.
- The scan-contamination root cause itself is still unconfirmed — the fingerprint-dedup defense
  in `scan.ps1`/`merge-data.ps1` catches the symptom, not the cause. If `suspiciousGitDataReused`
  or a merge warning shows up again, that's a live repro worth actually debugging (add
  `Write-Verbose` around `Invoke-GitTimeout`'s process handling).
