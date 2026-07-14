# Findings & Recommendations — Vibe Coders Portfolio

*Written 2026-07-14 after a full dashboard rebuild, a 126-project telemetry backlog, a live scan-
contamination bug found while acting on it, and a first live run of `autonomous-loop` against an
accessible project. Covers what was found, what it means, and what to do next.*

## 1. Executive summary

The portfolio dashboard is now accurate and live at
https://b0lk13.github.io/vibe-dashboard-final-20260710160005/, covering 126 first-party projects
across C:, D:, E:, and F:. Turning that scan into a backlog surfaced 290 telemetry-based tasks —
and, in the process of trying to act on the highest-priority ones, surfaced a real bug in the
scanner itself (not just in the target projects). Both are now fixed; what's left is mostly execution,
not more analysis: work through the backlog, and optionally point `autonomous-loop` — a separate
tool already in your portfolio (`D:\autonomous-loop`) — at individual projects for a deeper,
code-level pass than telemetry alone can give.

## 2. What was actually done this session

- Rebuilt and redeployed the dashboard (category bug, `GetExtension` crash, dead code removed,
  live URL, description).
- Generated a 290-task backlog across all 126 projects from scan telemetry: `backlog/tasks.json`
  (machine-readable), `backlog/<project>.md` (one per project), `backlog/MASTER_BACKLOG.md`
  (portfolio summary + cross-cutting findings).
- Tried to execute the top 5 "Critical" backlog items (large uncommitted-change counts) and found
  3 of them were fabricated by a scanner bug, not real. Fixed the scanner, not just the data — see
  §3.
- Ran `autonomous-loop` (an existing tool in your portfolio) against `vibe-dashboard` itself as a
  proof of concept — see §5.

## 3. The scan-contamination bug (highest-value finding)

Four unrelated projects — `development-agents`, `AI-shell`, `sharepoint-automation`, `mda-cli-v2`
— reported byte-identical git statistics (same branch, same commit count, same dates, same
uncommitted-change count) despite being unrelated projects at non-adjacent positions in the
scan list, across two different batch runs. Filesystem-derived fields (file count, README
presence) correctly differed for the same four, which narrowed the bug to the git-calling code
specifically. Live investigation confirmed two of the four (`development-agents`, `mda-cli-v2`)
have `.git` folders that exist but are completely empty right now — no `HEAD`, no objects, no
refs — so the reported "10 commits, 55 uncommitted changes" was fabricated, not stale.

**Why this matters beyond these 4 projects:** this was the *first time* anyone tried to act on the
backlog's data instead of just reading it, and it immediately found a correctness bug that had
been silently sitting in `scan-data.json` since the very first real scan. Any automated backlog
is only as trustworthy as its source data — worth remembering before fully trusting any of the
remaining 286 tasks, even though the specific contamination pattern found here only affected
these 4.

**Fixed** (not just patched): `scan.ps1` now verifies `.git\HEAD` actually exists before trusting
`hasGit`, and tracks every git-stats fingerprint within a run, nulling out and flagging any exact
repeat instead of silently writing it. `merge-data.ps1` warns on duplicate fingerprints across all
merged parts too. The 4 corrupted part files were deleted so a plain rescan redoes them.
**Root cause not confirmed** — the fix catches the symptom (duplicate output), not the mechanism
that produces it. If `suspiciousGitDataReused` or a merge warning appears again after a rescan,
that's a live repro worth actually debugging.

**Recommendation:** run `run-scan.ps1` once to refresh `development-agents`/`AI-shell`/
`sharepoint-automation`/`mda-cli-v2` with real data, and watch the console for any new
`SUSPICIOUS:` warning — that would mean the bug is still live elsewhere in the portfolio and just
hasn't been caught yet.

## 4. Portfolio-wide recommendations, prioritized

**Do first (data integrity / risk of loss):**
1. Rescan the 4 projects affected by §3 to get real data before trusting their backlog entries.
2. Commit the 2 confirmed-real "Critical" uncommitted-change items (`powerplatform-cli-wrapper`,
   `sharepoint-automation`) via `commit-backlog.ps1 -Phase Critical`, run locally.
3. **35 real projects have no git repository at all.** This is the single highest-leverage fix in
   the portfolio — it's the difference between having any history/backup and having none. See
   `MASTER_BACKLOG.md` for the full list; most are small/dormant, so this is mostly a 5-minute
   `git init && git add -A && git commit` per project, not a big lift.

**Do next (cleanup / signal-to-noise):**
4. **7 project names exist at multiple different paths** (`stoic-journal` ×3, `mda-cli`,
   `mda-cross-platform`, `obsidian-agent`, `template-android-app`, `black-agency-os-android`,
   `M365FoundationsCISReport`). Some of these may be intentional (e.g. a synced Android Studio
   project vs. a `development/` mirror); worth a quick pass to confirm which is canonical and
   either delete or clearly label the other as a mirror/backup.
5. **16 near-identical thin scaffolds under `development-webpages`** (single HTML/CSS/README,
   ≤5 commits, all from 2025) and **8 similar under `dashboards`** — batch-archive rather than
   tracking individually; they're diluting the dashboard's signal.
6. **2 vendor clones** (`flutter`, `homebrew`) dwarf every real project's numbers on the
   commits/contributors charts. Tag them in `scan.ps1` and exclude from those views (already
   flagged as a Known Limit in the dashboard's own README).
7. **4 scan-list entries point to paths that no longer exist.** Clean up `scan.ps1`'s project
   list or confirm they were intentionally moved.

**Do when there's time (health, not urgency):**
8. **20 projects dormant over a year, 32 more in the last 6–12 months.** A single triage pass —
   archive what's done, delete what was abandoned, note a next milestone for anything you intend
   to revive — clears most of the portfolio's long tail at once.
9. Work the remaining Medium/Low backlog items (missing READMEs, tech-stack recommendations like
   CI workflows and dependency pinning) opportunistically per-project rather than as a dedicated
   pass — see each project's `backlog/<slug>.md`.

## 5. Using `autonomous-loop` for deeper, per-project passes

The telemetry backlog above is metadata-only — no access to your other repos' actual source, so
it can flag "no tests" but can't tell you *what* to test. `D:\autonomous-loop` is a separate tool
already in your portfolio that closes that gap: pointed at a real repo, it analyzes language/
build/test/docs/security, scores release readiness across 6 weighted categories (tests, build,
lint, docs, security, completeness), and — in `full` strategy — can propose and apply small,
validated improvements with automatic git-checkpoint rollback on failure or regression.

**Proof of concept — ran it against `vibe-dashboard` itself** (analysis-only, no changes made):

| Category | Score | Passed |
|---|---|---|
| tests | 0.0 | ❌ |
| build | 1.0 | ✅ |
| lint | 1.0 | ✅ |
| docs | 0.33 | ❌ |
| security | 1.0 | ✅ |
| completeness | 0.25 | ❌ |

**Overall: 0.537 — BLOCKED** ("no automated tests", "5 missing MVP elements"). Full report:
[`backlog/autonomous-loop-runs/vibe-dashboard/run_report.md`](autonomous-loop-runs/vibe-dashboard/run_report.md).
This is a fair result — the dashboard has never had automated tests — and it's a genuinely
different signal than the telemetry backlog: "no tests" wasn't something `scan.ps1` could ever
have told you.

**Limitation hit trying to go further:** this session only has file access to `D:\project-dashboard`,
`D:\autonomous-loop`, and `F:\development` (partially — see the commit-backlog work for why some
paths under it aren't reliably readable here). Running `autonomous-loop` against the other ~120
projects, or dogfooding it against its own (much larger) codebase, isn't reliable from this sandbox.
`run-autonomous-loop-backlog.ps1` (added alongside this report) does the same phased-by-priority
loop locally instead, where none of that applies.

**Recommended usage pattern:**
1. Start with `-Strategy analysis-only` (default, makes no changes) to get a release-readiness
   score and blocker list per project — cheap, safe, informative on its own.
2. For projects you actually want improved, re-run with `-Strategy full`. It git-checkpoints
   before every change and reverts automatically on test failure or regression, so it's safe to
   point at real repos unattended — but review its commits afterward regardless.
3. Prioritize by the same Critical → High → Medium phases as the rest of the backlog, since
   running this against all 126 projects in one pass would take a long time.

## 6. Suggested loop order

Putting §4 and §5 together, a reasonable sequence:

1. Rescan the 4 contaminated projects; confirm no new `SUSPICIOUS:` warnings.
2. `commit-backlog.ps1 -Phase Critical`, then `-Phase High` once you've spot-checked a few.
3. `git init` pass on the 35 no-git projects (script-able, but worth skimming each one first —
   some may be intentionally untracked, e.g. output/cache dirs).
4. `run-autonomous-loop-backlog.ps1 -Phase Critical -Strategy analysis-only` to get real
   readiness scores on the highest-priority projects; graduate to `-Strategy full` project by
   project as you review results.
5. Batch-archive decision on the `development-webpages`/`dashboards` scaffold clusters and the
   7 duplicate-name projects.
6. Everything else (dormancy triage, tech-stack recommendations) opportunistically, using the
   dashboard and per-project backlogs as your reference rather than a forced pass.
