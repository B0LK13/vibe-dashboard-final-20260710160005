# merge-data.ps1 · combines scan-parts\*.json into scan-data.json and injects the result
# into index.html's embedded <script id="scan-data"> block. Safe to re-run any time.
# Rollback: git checkout -- index.html scan-data.json (this repo is git-tracked).
$root = 'D:\project-dashboard\vibe-dashboard'
$partsDir = Join-Path $root 'scan-parts'
$parts = Get-ChildItem $partsDir -Filter *.json -ErrorAction Stop | Sort-Object Name
if (-not $parts) { throw "No part files in $partsDir - run scan.ps1 first." }

$all = foreach ($f in $parts) { Get-Content $f.FullName -Raw -Encoding utf8 | ConvertFrom-Json }
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
$pattern = '(?s)(<scri