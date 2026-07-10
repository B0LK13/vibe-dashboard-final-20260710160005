$ErrorActionPreference = 'Continue'
foreach ($b in 0..5) {
  try { & 'D:\project-dashboard\vibe-dashboard\scan.ps1' -Start ($b * 12) -End ($b * 12 + 11) }
  catch { "BATCH $b FAILED: $_" | Out-File 'D:\project-dashboard\vibe-dashboard\scan-progress.txt' -Append }
}
'ALL_DONE' | Out-File 'D:\project-dashboard\vibe-dashboard\scan-done.txt' -Encoding utf8
