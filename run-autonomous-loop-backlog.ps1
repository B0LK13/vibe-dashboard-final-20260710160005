# run-autonomous-loop-backlog.ps1 - point D:\autonomous-loop's CLI at each project in the
# telemetry backlog, phase by phase (Critical -> High -> Medium), for a deeper release-readiness
# analysis than scan-data.json's metadata alone can give.
#
# Why this exists: this only works from a real Windows/PowerShell session with autonomous-loop
# installed and access to all your drives -- the dashboard's Claude session could only reach a
# handful of projects (D:\project-dashboard, D:\autonomous-loop, partial F:\development) and
# background/long-running processes don't survive across its tool calls, so a full portfolio
# loop has to run locally. See backlog\FINDINGS_AND_RECOMMENDATIONS.md section 5.
#
# Prerequisite: pip install <path-to>\autonomous-loop\dist\autonomous_loop-0.1.0rc1-py3-none-any.whl
# (or `pip install -e .` from within D:\autonomous-loop for editable/dev use).
#
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File run-autonomous-loop-backlog.ps1 `
#     [-Phase Critical] [-Strategy analysis-only] [-MaxIterations 2] [-BudgetMinutes 5] [-WhatIf]
#
# -Phase         : Critical | High | Medium | All (default: Critical) -- a project is included
#                  in a phase if ANY of its backlog tasks has that priority.
# -Strategy      : analysis-only (default, makes no changes) | full (proposes + applies small
#                  validated improvements, git-checkpointed with automatic revert on regression)
# -MaxIterations : passed through to autonomous-loop (default 2)
# -BudgetMinutes : passed through to autonomous-loop, per project (default 5)
# -WhatIf        : list what would run without actually running it
param(
  [ValidateSet('Critical', 'High', 'Medium', 'All')]
  [string]$Phase = 'Critical',
  [ValidateSet('analysis-only', 'full')]
  [string]$Strategy = 'analysis-only',
  [int]$MaxIterations = 2,
  [int]$BudgetMinutes = 5,
  [switch]$WhatIf
)

$root = 'D:\project-dashboard\vibe-dashboard'
$tasks = (Get-Content (Join-Path $root 'backlog\tasks.json') -Raw | ConvertFrom-Json).tasks
$reportRoot = Join-Path $root 'backlog\autonomous-loop-runs'
New-Item -ItemType Directory -Path $reportRoot -Force | Out-Null

if (-not (Get-Command autonomous-loop -ErrorAction SilentlyContinue)) {
  Write-Error "autonomous-loop CLI not found on PATH. Install it first: pip install <path>\autonomous-loop\dist\autonomous_loop-0.1.0rc1-py3-none-any.whl"
  return
}

$priorityRank = @{ Critical = 0; High = 1; Medium = 2; Low = 3 }
$phases = if ($Phase -eq 'All') { @('Critical', 'High', 'Medium') } else { @($Phase) }
$minRankWanted = ($phases | ForEach-Object { $priorityRank[$_] } | Measure-Object -Maximum).Maximum

# vendor clones and paths already known to be missing aren't worth a code-level pass here
$excludeNames = @('flutter', 'homebrew')

$byProject = $tasks | Where-Object { $excludeNames -notcontains $_.projectName } | Group-Object projectPath
$targets = foreach ($grp in $byProject) {
  $best = ($grp.Group | ForEach-Object { $priorityRank[$_.priority] } | Measure-Object -Minimum).Minimum
  if ($best -le $minRankWanted) {
    [pscustomobject]@{
      Path = $grp.Name
      Name = $grp.Group[0].projectName
      Slug = $grp.Group[0].projectSlug
      BestRank = $best
    }
  }
}
$targets = $targets | Sort-Object BestRank, Name

if (-not $targets) {
  Write-Output "No projects found for phase(s): $($phases -join ', ')"
  return
}

Write-Output "Phase(s): $($phases -join ', ') -- Strategy: $Strategy -- $($targets.Count) project(s)"
Write-Output ''

$results = @()
foreach ($t in $targets) {
  Write-Output "=== $($t.Name) ($($t.Path)) ==="
  if (-not (Test-Path $t.Path)) {
    Write-Output "  SKIP: path not found"
    $results += [pscustomobject]@{ Project = $t.Name; Result = 'skip-missing' }
    continue
  }

  $reportDir = Join-Path $reportRoot $t.Slug
  New-Item -ItemType Directory -Path $reportDir -Force | Out-Null

  if ($WhatIf) {
    Write-Output "  [WhatIf] would run: autonomous-loop --repo `"$($t.Path)`" --strategy $Strategy --no-approval --max-iterations $MaxIterations --budget-minutes $BudgetMinutes --report-dir `"$reportDir`" --json"
    $results += [pscustomobject]@{ Project = $t.Name; Result = 'whatif' }
    continue
  }

  $json = autonomous-loop --repo $t.Path --strategy $Strategy --no-approval `
    --max-iterations $MaxIterations --budget-minutes $BudgetMinutes `
    --report-dir $reportDir --json 2>&1 | Select-Object -Last 1
  try {
    $parsed = $json | ConvertFrom-Json
    Write-Output "  score $($parsed.score) -- $($parsed.status) -- $($parsed.recommendation)"
    $results += [pscustomobject]@{ Project = $t.Name; Result = $parsed.status; Score = $parsed.score }
  } catch {
    Write-Output "  FAILED or unparseable output -- see console above"
    $results += [pscustomobject]@{ Project = $t.Name; Result = 'error' }
  }
  Write-Output ''
}

Write-Output '=== Summary ==='
$results | Format-Table -AutoSize
Write-Output "Full reports under: $reportRoot\<project-slug>\run_report.md"
