# run-scan.ps1 · one command to refresh the whole dashboard
#   powershell -NoProfile -ExecutionPolicy Bypass -File D:\project-dashboard\vibe-dashboard\run-scan.ps1
# Each batch runs in a fresh -NoProfile child process (v1 hangs were never isolated;
# profile scripts are a prime suspect). scan.ps1 is resumable, so re-running after a
# crash just picks up where it left off. Add -Force inside scan.ps1 call to rescan all.
$ErrorActionPreference = 'Continue'
$root = 'D:\project-dashboard\vibe-dashboard'

$batch = 15
# Upper bound is intentionally generous (well above the current 126-project list in scan.ps1)
# rather than hand-synced to the exact count: scan.ps1 clamps End to Min(End, projects.Count-1),
# so batches past the real count just no-op instantly. A tight hardcoded bound (previously 135)
# silently stops scanning early if the project list grows without this number being updated too.
for ($s = 0; $s -lt 200; $s += $batch) {
  try {
    powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $root 'scan.ps1') -Start $s -End ($s + $batch - 1)
  } catch { "BATCH $s FAILED: $_" | Out-File (Join-Path $root 'scan-progress.txt') -Append -Encoding utf8 }
}

powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $root 'merge-data.ps1')
'ALL_DONE ' + (Get-Date -Format s) | Out-File (Join-Path $root 'scan-done.txt') -Encoding utf8
Write-Output 'Scan + merge complete. Open index.html to view the refreshed dashboard.'
