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
