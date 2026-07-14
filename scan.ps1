# vibe-dashboard scanner v2 · 2026-07-10 · rewritten by Claude (autonomous-dev-loop)
# v1 hung on its first git call five times in a row (see scan-progress.txt) and lost all
# progress on every crash. v2 fixes both failure modes:
#   1. every git call runs in a child process with a hard 15s timeout (kill on expiry)
#   2. each project writes its own JSON part file immediately -> crash-safe + resumable
# Usage:  powershell -NoProfile -ExecutionPolicy Bypass -File scan.ps1 [-Start n] [-End n] [-Force]
# Re-runs skip projects that already have a part file unless -Force is given.
# Rollback: git checkout -- scan.ps1 (this repo is git-tracked; .bak files were retired 2026-07-14).
param([int]$Start = 0, [int]$End = 9999, [switch]$Force)

$root = 'D:\project-dashboard\vibe-dashboard'
$partsDir = Join-Path $root 'scan-parts'
New-Item -ItemType Directory -Path $partsDir -Force | Out-Null
$env:GIT_TERMINAL_PROMPT = '0'
$env:GIT_OPTIONAL_LOCKS = '0'

# Full first-party project list · from the 2026-07-10 four-drive inventory
$projects = @(
  'D:\ai-fintech','D:\AndroidProjects\black-agency-os-android','D:\AndroidProjects\daily-trendscape','D:\AndroidProjects\project-pulse-android','D:\AndroidProjects\stoic-journal','D:\AndroidProjects\template-android-app','D:\AndroidProjects\vibe-dashboard-android','D:\autonomous-loop','D:\cursor-optimization-project','D:\fable5\ados','D:\fable5\black-agency-os','D:\flutter','D:\project-llm-wiki',
  'D:\project-dashboard\vibe-dashboard','D:\huggingface-downloader','D:\manus-llm-chat-exporter','D:\nexus-macos','D:\obsidian-plugin','D:\black-agency-web-design','D:\Projects\flutter_verify','D:\Projects\HelloVerify',
  'C:\Users\Admin\StudioProjects\black-agency-os-android','C:\Users\Admin\StudioProjects\stoic-journal','C:\Users\Admin\Documents\antigravity\fervent-franklin',
  'E:\Chrome Extension for LLM Response Clipping to Obsidian','E:\PowerShell\Source\M365FoundationsCISReport',
  'F:\mda-cli','F:\mda-cross-platform','F:\cloudbase-mcp','F:\project-os-genx','F:\vibe-dev','F:\pipelines','F:\src',
  'F:\development\B0LK13s-dark-factory','F:\development\bun\obsidian-agent','F:\development\development-agents','F:\development\development-agents\Agents','F:\development\development-agents\Agents\hermes-agent','F:\development\development-agents\ai-shell\AI-shell','F:\development\development-agents\ai-shell\AIShell','F:\development\development-agents\ai-agents\obsidian-agent',
  'F:\development\development-apps\creator-kit-app','F:\development\development-apps\euro_subtracker','F:\development\development-apps\EuroSubTrackerPro','F:\development\development-apps\fast-api-app',
  'F:\development\development-authenticatie\GithubAcces','F:\development\development-automation\autoresearch-loop',
  'F:\development\development-cloud\cloud-dashboard','F:\development\development-cloud\multi-environment','F:\development\development-cloud\cloud-development-google\gcp-cli','F:\development\development-cloud\cloud-development-microsoft\sharepoint-ssot-mcp','F:\development\development-cloud\cloud-hostinger\vps-cli','F:\development\development-cloud\cloud-infra\proxmox_development',
  'F:\development\development-dashboards\dashboards\cloudflare_dashboard','F:\development\development-dashboards\dashboards\cloud_dashboard','F:\development\development-dashboards\dashboards\email_intel_dashboard','F:\development\development-dashboards\dashboards\file_dashboard','F:\development\development-dashboards\dashboards\huisvesting_dashboard','F:\development\development-dashboards\dashboards\status-dashboard','F:\development\development-dashboards\dashboards\tech_analyse_dashboard','F:\development\development-dashboards\dashboards\trading_dashboard',
  'F:\development\development-demos\docker-scout-demo-service','F:\development\development-demos\WebView2Demo',
  'F:\development\development-local','F:\development\development-local\local-ai-packaged','F:\development\development-local\android-command-center','F:\development\development-local\bootstrap-workstation','F:\development\development-local\file-management-tool','F:\development\development-local\windows-optimization',
  'F:\development\development-management\ip-address-management-ipam','F:\development\development-notes',
  'F:\development\development-projects\context-engineering-intro','F:\development\development-projects\hello-ai','F:\development\development-projects\inbox_zen','F:\development\development-projects\my-fastapi-app','F:\development\development-projects\open-deep-research','F:\development\development-projects\self-hosted-ai-starter-kit','F:\development\development-projects\self-hosted-ai-starter-kit2','F:\development\development-projects\youtube-generator',
  'F:\development\development-projects\automation\crawl-for-ai-rag','F:\development\development-projects\chrome-extensies\finance_tracker','F:\development\development-projects\chrome-extensies\mermaid_diagram_editor','F:\development\development-projects\document-processing-projects\automated_document_hub','F:\development\development-projects\microsoft-projects\powerplatform-cli-wrapper','F:\development\development-projects\microsoft-projects\sharepoint-automation','F:\development\development-projects\note-processing-projects\mda-cli','F:\development\development-projects\note-processing-projects\mda-cli-new','F:\development\development-projects\note-processing-projects\mda-cli-v2','F:\development\development-projects\note-processing-projects\obsidian-nexus','F:\development\development-projects\vibe-coding-apps\citation-cleanup-tui','F:\development\development-projects\vibe-coding-apps\mda-cross-platform','F:\development\development-projects\vibe-coding-apps\vibed-dev-env',
  'F:\development\development-scripting\scripting-json','F:\development\development-scripting\scripting-powershell','F:\development\development-scripting\scripting-python',
  'F:\development\development-security\10-security\intelligence_report','F:\development\development-security\10-security\operational_security','F:\development\development-security\10-security\security_portal',
  'F:\development\development-software-and-tools\homebrew',
  'F:\development\development-webpages\cyber_warfare_group','F:\development\development-webpages\cyber-command-center','F:\development\development-webpages\deepsite_projects','F:\development\development-webpages\digital_architect','F:\development\development-webpages\digital_CV','F:\development\development-webpages\digital_mandate','F:\development\development-webpages\docu_core','F:\development\development-webpages\gcp','F:\development\development-webpages\gemini-created-webpages','F:\development\development-webpages\hapi_interactive_manual','F:\development\development-webpages\huggingface_spaces','F:\development\development-webpages\nullsector','F:\development\development-webpages\omega_secure','F:\development\development-webpages\rag_chat','F:\development\development-webpages\rootweb3.0','F:\development\development-webpages\social_spark','F:\development\development-webpages\stormcommando','F:\development\development-webpages\technomad','F:\development\development-webpages\terminal_chat','F:\development\development-webpages\the_modern_survival_,manual','F:\development\development-webpages\gas-showcase-platform',
  'F:\development\dotfiles','F:\development\productivity-manager-extension','F:\development\PowerShell\Source\M365FoundationsCISReport','F:\development\projects\stoic-journal','F:\development\template-android-app','F:\development\template-compose-stack'
)

$codeExt = '^\.(ts|tsx|js|jsx|py|kt|java|cs|go|rs|dart|html|css|md|ps1|sh|json|yml|yaml|php|vue|svelte)$'

# [System.IO.Path]::GetExtension() throws on filenames with characters Windows considers
# illegal in a path (seen for real on project-llm-wiki: 'Illegal characters in path' killed
# the whole try block, silently dropping fileCount/topExtensions/lastModified/hasReadme for
# that project). Regex-based extraction never throws — worst case it just returns ''.
function Get-ExtSafe { param([string]$Name) if ($Name -match '(\.[A-Za-z0-9]+)$') { $Matches[1] } else { '' } }

function Invoke-GitTimeout {
  param([string]$Repo, [string]$GitArgs, [int]$TimeoutSec = 15)
  try {
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = 'git'
    $psi.Arguments = ('-C "{0}" --no-optional-locks {1}' -f $Repo, $GitArgs)
    $psi.UseShellExecute = $false; $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true; $psi.CreateNoWindow = $true
    $proc = [System.Diagnostics.Process]::Start($psi)
    $stdout = $proc.StandardOutput.ReadToEndAsync()
    $null = $proc.StandardError.ReadToEndAsync()
    if (-not $proc.WaitForExit($TimeoutSec * 1000)) {
      try { $proc.Kill() } catch {}
      return $null   # timed out -> caller records null, loop continues
    }
    if ($proc.ExitCode -ne 0) { return $null }
    return $stdout.Result.TrimEnd()
  } catch { return $null }
}

$progress = Join-Path $root 'scan-progress.txt'
for ($i = $Start; $i -le [Math]::Min($End, $projects.Count - 1); $i++) {
  $p = $projects[$i]
  $slug = ($p -replace '[:\\/ ]', '_').Trim('_')
  $part = Join-Path $partsDir "$slug.json"
  if ((Test-Path $part) -and -not $Force) { continue }
  "$(Get-Date -Format HH:mm:ss) [$i] $p" | Out-File $progress -Append -Encoding utf8

  $parentLeaf = Split-Path (Split-Path $p -Parent) -Leaf
  # drive-root projects (e.g. D:\ai-fintech): Split-Path -Leaf on a bare drive root
  # ('D:\') returns the root itself ('D:\'), NOT an empty string as you'd expect —
  # first attempt at this fix assumed empty-string and missed real drive-root paths
  # entirely (confirmed against a real scan: category came out as literal "D:\").
  # Match that case explicitly and fall back to the "<Drive>-root" convention used
  # everywhere else (EXTRAS list, docs).
  $category = if ($parentLeaf -match '^[A-Za-z]:\\?$') { "$($p.Substring(0,1))-root" } else { $parentLeaf }
  $obj = [ordered]@{ name = (Split-Path $p -Leaf); path = $p; drive = $p.Substring(0,1); category = $category }
  try {
    if (-not (Test-Path $p)) { $obj.missing = $true; $obj.hasGit = $false }
    else {
      # 2026-07-14: Test-Path '.git' alone isn't enough -- seen for real on development-agents
      # and mda-cli-v2, whose .git dirs exist but are completely empty (no HEAD/objects/refs),
      # yet still reported hasGit:true with fabricated-looking commit stats. Require HEAD to
      # actually exist before trusting anything git-derived.
      $isGit = (Test-Path (Join-Path $p '.git')) -and (Test-Path (Join-Path $p '.git\HEAD'))
      $obj.hasGit = $isGit
      if ($isGit) {
        $obj.branch         = Invoke-GitTimeout $p 'rev-parse --abbrev-ref HEAD'
        $v = Invoke-GitTimeout $p 'rev-list --count HEAD';                       $obj.totalCommits = if ($v) { [int]$v } else { 0 }
        $obj.lastCommitDate = Invoke-GitTimeout $p 'log -1 --format=%cs'
        $v = Invoke-GitTimeout $p 'rev-list --count --since="30 days ago" HEAD'; $obj.commits30d = if ($v) { [int]$v } else { 0 }
        $v = Invoke-GitTimeout $p 'rev-list --count --since="90 days ago" HEAD'; $obj.commits90d = if ($v) { [int]$v } else { 0 }
        $v = Invoke-GitTimeout $p 'status --porcelain -uno' 30
        $obj.uncommitted    = if ($null -ne $v) { @($v -split "`n" | Where-Object { $_ }).Count } else { $null }
        # full-history unique author count, not capped at 200 commits (was 'log -n 200' —
        # undercounts contributors on any repo with >200 commits in its history)
        $v = Invoke-GitTimeout $p 'log --all --pretty=%an' 30
        $obj.contributors   = if ($v) { @($v -split "`n" | Where-Object { $_ } | Sort-Object -Unique).Count } else { $null }

        # 2026-07-14: found 4 unrelated projects (development-agents, AI-shell,
        # sharepoint-automation, mda-cli-v2), NOT adjacent in $projects and split across two
        # different batch/process runs, with byte-identical git-derived stats
        # (branch/totalCommits/dates/uncommitted/contributors) while their filesystem-derived
        # fields correctly differed -- root cause not confirmed (possibly Invoke-GitTimeout's
        # unawaited ReadToEndAsync racing under load, or something in how failed/timed-out
        # calls fall through), but this catches the *symptom* regardless of cause: track every
        # git fingerprint seen so far in this run, and if the current project's exactly repeats
        # an earlier one, don't trust it -- null the fields out and flag for a rescan instead of
        # silently propagating a copy into scan-data.json.
        if (-not $script:seenGitFingerprints) { $script:seenGitFingerprints = @{} }
        $fingerprint = "$($obj.branch)|$($obj.totalCommits)|$($obj.lastCommitDate)|$($obj.commits30d)|$($obj.commits90d)|$($obj.uncommitted)|$($obj.contributors)"
        if ($script:seenGitFingerprints.ContainsKey($fingerprint)) {
          $obj.suspiciousGitDataReused = $true
          $obj.suspiciousGitDataDupeOf = $script:seenGitFingerprints[$fingerprint]
          $obj.branch = $null; $obj.totalCommits = $null; $obj.lastCommitDate = $null
          $obj.commits30d = $null; $obj.commits90d = $null; $obj.uncommitted = $null; $obj.contributors = $null
        } else {
          $script:seenGitFingerprints[$fingerprint] = $p
        }
        $tracked = Invoke-GitTimeout $p 'ls-files' 30
        if ($null -ne $tracked) {
          $files = @($tracked -split "`n" | Where-Object { $_ })
          $obj.fileCount = $files.Count
          $extGroups = $files | ForEach-Object { Get-ExtSafe $_ } | Where-Object { $_ -match $codeExt } | Group-Object | Sort-Object Count -Descending | Select-Object -First 3
          $obj.topExtensions = ($extGroups | ForEach-Object { "$($_.Name):$($_.Count)" }) -join ','
        } else { $obj.fileCount = $null; $obj.topExtensions = '' }
        $obj.lastModified = $obj.lastCommitDate
      } else {
        $files = Get-ChildItem -Path $p -Recurse -Depth 2 -File -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch 'node_modules|\.venv|__pycache__|build\\|dist\\' } | Select-Object -First 800
        $obj.fileCount = @($files).Count
        $obj.lastModified = if ($obj.fileCount -gt 0) { ($files | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime.ToString('yyyy-MM-dd') } else { $null }
        $extGroups = $files | Group-Object Extension | Where-Object { $_.Name -match $codeExt } | Sort-Object Count -Descending | Select-Object -First 3
        $obj.topExtensions = ($extGroups | ForEach-Object { "$($_.Name):$($_.Count)" }) -join ','
      }
      $obj.hasReadme = [bool](Get-ChildItem -Path $p -Filter 'README*' -ErrorAction SilentlyContinue | Select-Object -First 1)
    }
  } catch { $obj.error = "$_" }
  [pscustomobject]$obj | ConvertTo-Json -Depth 3 | Out-File $part -Encoding utf8
}
Write-Output "BATCH $Start-$End done. Parts in scan-parts\ ($((Get-ChildItem $partsDir -Filter *.json).Count)/$($projects.Count))"
