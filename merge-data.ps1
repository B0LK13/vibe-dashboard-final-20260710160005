# merge-data.ps1 · combines scan-parts\*.json into scan-data.json and injects the result
# into index.html's embedded <script id="scan-data"> block. Safe to re-run any time.
# Rollback: git checkout -- index.html scan-data.json (this repo is git-tracked).
$root = 'D:\project-dashboard\vibe-dashboard'
$partsDir = Join-Path $root 'scan-parts'
$parts = Get-ChildItem $partsDir -Filter *.json -ErrorAction Stop | Sort-Object Name
if (-not $parts) { throw "No part files in $partsDir - run scan.ps1 first." }

$all = foreach ($f in $parts) { Get-Content $f.FullName -Raw -Encoding utf8 | ConvertFrom-Json }

# 2026-07-14: cross-project duplicate-stats detector. scan.ps1 now self-flags this within a
# single run (suspiciousGitDataReused), but this catches it across runs/batches too -- e.g. if
# an older part file from before that fix is still sitting in scan-parts\. Any two DIFFERENT
# projects sharing the exact same non-null (branch, totalCommits, lastCommitDate, uncommitted,
# contributors) tuple is not a coincidence; it's scan contamination (seen for real: development-
# agents, AI-shell, sharepoint-automation, mda-cli-v2 all reported identically).
$seen = @{}
foreach ($proj in $all) {
  if (-not $proj.hasGit -or $null -eq $proj.totalCommits) { continue }
  $fp = "$($proj.branch)|$($proj.totalCommits)|$($proj.lastCommitDate)|$($proj.uncommitted)|$($proj.contributors)"
  if ($seen.ContainsKey($fp)) {
    Write-Warning "SUSPICIOUS: '$($proj.name)' ($($proj.path)) has identical git stats to '$($seen[$fp])' -- likely scan contamination, not a coincidence. Delete both part files in scan-parts\ and rescan with -Force."
  } else {
    $seen[$fp] = "$($proj.name) ($($proj.path))"
  }
}

$json = ConvertTo-Json @($all) -Depth 4 -Compress
$mergedAt = Get-Date -Format 's'

# 0. dated snapshot of the previous scan-data.json before it's overwritten, for future trend charts
$dataPath = Join-Path $root 'scan-data.json'
if (Test-Path $dataPath) {
  $snapDir = Join-Path $root 'snapshots'
  New-Item -ItemType Directory -Path $snapDir -Force | Out-Null
  $stamp = Get-Date -Format 'yyyy-MM-dd_HHmmss'
  Copy-Item $dataPath (Join-Path $snapDir "scan-data_$stamp.json") -Force
}

# 1. standalone data file
$json | Out-File $dataPath -Encoding utf8

# 2. inject into dashboard (MatchEvaluator avoids $-substitution issues inside JSON)
$htmlPath = Join-Path $root 'index.html'
$html = Get-Content $htmlPath -Raw -Encoding utf8
$pattern = '(?s)(<script id="scan-data" type="application/json">).*?(</script>)'
$evaluator = { param($m) $m.Groups[1].Value + $json + $m.Groups[2].Value }.GetNewClosure()
$new = [regex]::Replace($html, $pattern, $evaluator)
if ($new -eq $html) { Write-Warning 'scan-data block not found or unchanged in index.html' }

# 3. stamp the merge timestamp + project count so index.html can render a live scanInfo line
# instead of hand-typed dates that go stale (see SCAN_META block near the top of the <script>)
$metaJson = "{`"mergedAt`":`"$mergedAt`",`"count`":$($all.Count)}"
$metaPattern = '(?s)(<script id="scan-meta" type="application/json">).*?(</script>)'
$metaEvaluator = { param($m) $m.Groups[1].Value + $metaJson + $m.Groups[2].Value }.GetNewClosure()
$new = [regex]::Replace($new, $metaPattern, $metaEvaluator)
Set-Content $htmlPath -Value $new -Encoding utf8 -NoNewline

Write-Output "Merged $($all.Count) projects into scan-data.json and index.html (snapshot saved, meta stamped $mergedAt)"
