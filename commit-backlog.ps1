# commit-backlog.ps1 - go through the portfolio's "uncommitted changes" backlog items
# phase by phase (Critical -> High -> Medium) and commit them, one project at a time.
#
# Why this exists: the dashboard's Claude session can't reliably execute git commands
# against these repos (F:\ drive file materialization + git lock issues seen live on
# 2026-07-14), so this runs locally instead, where none of that applies.
#
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File commit-backlog.ps1 [-Phase Critical] [-Message "..."] [-WhatIf]
#
# -Phase      : Critical | High | Medium | All (default: Critical)
# -Message    : commit message to use (default: "WIP: checkpoint via vibe-dashboard backlog")
# -WhatIf     : show what would happen without actually committing
param(
  [ValidateSet('Critical', 'High', 'Medium', 'All')]
  [string]$Phase = 'Critical',
  [string]$Message = 'WIP: checkpoint via vibe-dashboard backlog',
  [switch]$WhatIf
)

$root = 'D:\project-dashboard\vibe-dashboard'
$tasks = (Get-Content (Join-Path $root 'backlog\tasks.json') -Raw | ConvertFrom-Json).tasks

$phases = if ($Phase -eq 'All') { @('Critical', 'High', 'Medium') } else { @($Phase) }

$targets = $tasks | Where-Object {
  $phases -contains $_.priority -and $_.title -like 'Commit or clean up*'
}

if (-not $targets) {
  Write-Output "No 'Commit or clean up' tasks found for phase(s): $($phases -join ', ')"
  return
}

Write-Output "Phase(s): $($phases -join ', ') -- $($targets.Count) project(s) to process"
Write-Output ''

$results = @()
foreach ($t in $targets) {
  $p = $t.projectPath
  Write-Output "=== [$($t.priority)] $($t.projectName) ($p) ==="

  if (-not (Test-Path (Join-Path $p '.git'))) {
    Write-Output "  SKIP: no .git found"
    $results += [pscustomobject]@{ Project = $t.projectName; Path = $p; Result = 'skip-no-git' }
    continue
  }

  $lockFile = Join-Path $p '.git\index.lock'
  if (Test-Path $lockFile) {
    $age = (Get-Date) - (Get-Item $lockFile).LastWriteTime
    if ($age.TotalMinutes -lt 5) {
      Write-Output "  SKIP: .git\index.lock is $([int]$age.TotalSeconds)s old -- a git process may genuinely be running. Close it and re-run."
      $results += [pscustomobject]@{ Project = $t.projectName; Path = $p; Result = 'skip-active-lock' }
      continue
    } else {
      Write-Output "  .git\index.lock is stale ($([int]$age.TotalMinutes) min old) -- removing."
      if (-not $WhatIf) { Remove-Item $lockFile -Force }
    }
  }

  $status = git -C $p status --porcelain 2>&1
  $count = @($status -split "`n" | Where-Object { $_ }).Count
  if ($count -eq 0) {
    Write-Output "  clean already (0 pending changes) -- nothing to do"
    $results += [pscustomobject]@{ Project = $t.projectName; Path = $p; Result = 'already-clean' }
    continue
  }

  Write-Output "  $count pending change(s)"
  if ($WhatIf) {
    Write-Output "  [WhatIf] would run: git add -A; git commit -m `"$Message`""
    $results += [pscustomobject]@{ Project = $t.projectName; Path = $p; Result = 'whatif' }
    continue
  }

  git -C $p add -A
  git -C $p commit -m $Message | Out-Null
  if ($LASTEXITCODE -eq 0) {
    $sha = (git -C $p log -1 --format='%h').Trim()
    Write-Output "  committed $sha"
    $results += [pscustomobject]@{ Project = $t.projectName; Path = $p; Result = "committed $sha" }
  } else {
    Write-Output "  COMMIT FAILED (exit $LASTEXITCODE)"
    $results += [pscustomobject]@{ Project = $t.projectName; Path = $p; Result = 'commit-failed' }
  }
  Write-Output ''
}

Write-Output '=== Summary ==='
$results | Format-Table -AutoSize
