param([int]$Start, [int]$End)
$projects = @('D:\ai-fintech','D:\AndroidProjects\black-agency-os-android','D:\AndroidProjects\daily-trendscape','D:\AndroidProjects\project-pulse-android','D:\AndroidProjects\stoic-journal','D:\AndroidProjects\template-android-app','D:\AndroidProjects\vibe-dashboard-android','D:\autonomous-loop','D:\cursor-optimization-project','D:\fable5\ados','D:\fable5\black-agency-os','D:\flutter','D:\project-llm-wiki','F:\development\B0LK13s-dark-factory','F:\development\bun\obsidian-agent','F:\development\development-agents','F:\development\development-apps\creator-kit-app','F:\development\development-apps\euro_subtracker','F:\development\development-apps\EuroSubTrackerPro','F:\development\development-apps\fast-api-app','F:\development\development-authenticatie\GithubAcces','F:\development\development-automation\autoresearch-loop','F:\development\development-cloud\cloud-dashboard','F:\development\development-cloud\multi-environment','F:\development\development-demos\docker-scout-demo-service','F:\development\development-demos\WebView2Demo','F:\development\development-local','F:\development\development-management\ip-address-management-ipam','F:\development\development-notes','F:\development\development-projects\context-engineering-intro','F:\development\development-projects\hello-ai','F:\development\development-projects\inbox_zen','F:\development\development-projects\my-fastapi-app','F:\development\development-projects\open-deep-research','F:\development\development-projects\self-hosted-ai-starter-kit','F:\development\development-projects\self-hosted-ai-starter-kit2','F:\development\development-projects\youtube-generator','F:\development\development-scripting\scripting-json','F:\development\development-scripting\scripting-powershell','F:\development\development-scripting\scripting-python','F:\development\development-software-and-tools\homebrew','F:\development\development-webpages\cyber_warfare_group','F:\development\development-webpages\cyber-command-center','F:\development\development-webpages\deepsite_projects','F:\development\development-webpages\digital_architect','F:\development\development-webpages\digital_CV','F:\development\development-webpages\digital_mandate','F:\development\development-webpages\docu_core','F:\development\development-webpages\gcp','F:\development\development-webpages\gemini-created-webpages','F:\development\development-webpages\hapi_interactive_manual','F:\development\development-webpages\huggingface_spaces','F:\development\development-webpages\nullsector','F:\development\development-webpages\omega_secure','F:\development\development-webpages\rag_chat','F:\development\development-webpages\rootweb3.0','F:\development\development-webpages\social_spark','F:\development\development-webpages\stormcommando','F:\development\development-webpages\technomad','F:\development\development-webpages\terminal_chat','F:\development\development-webpages\the_modern_survival_,manual','F:\development\dotfiles','F:\development\git-credential-manager','F:\development\projects\stoic-journal','F:\development\template-android-app','F:\development\template-compose-stack')

$codeExt = '^\.(ts|tsx|js|jsx|py|kt|java|cs|go|rs|dart|html|css|md|ps1|sh|json|yml|yaml|php|vue|svelte)$'
$env:GIT_TERMINAL_PROMPT = '0'
$env:GIT_OPTIONAL_LOCKS = '0'
$results = @()
for ($i = $Start; $i -le [Math]::Min($End, $projects.Count - 1); $i++) {
  $p = $projects[$i]
  "$(Get-Date -Format HH:mm:ss) [$i] $p" | Out-File 'D:\project-dashboard\vibe-dashboard\scan-progress.txt' -Append -Encoding utf8
  $obj = [ordered]@{ name = (Split-Path $p -Leaf); path = $p; drive = $p.Substring(0,1); category = (Split-Path (Split-Path $p -Parent) -Leaf) }
  $isGit = Test-Path (Join-Path $p '.git')
  $obj.hasGit = $isGit
  if ($isGit) {
    $obj.branch        = (git -C $p rev-parse --abbrev-ref HEAD 2>$null)
    $obj.totalCommits  = [int](git -C $p rev-list --count HEAD 2>$null)
    $obj.lastCommitDate = (git -C $p log -1 --format=%cs 2>$null)
    $obj.commits30d    = [int](git -C $p rev-list --count --since="30 days ago" HEAD 2>$null)
    $obj.commits90d    = [int](git -C $p rev-list --count --since="90 days ago" HEAD 2>$null)
    $obj.uncommitted   = [int]((git -C $p status --porcelain -uno 2>$null | Measure-Object).Count)
    $obj.contributors  = [int]((git -C $p log --pretty=%an -n 200 2>$null | Sort-Object -Unique | Measure-Object).Count)
    $tracked = git -C $p ls-files 2>$null
    $obj.fileCount = ($tracked | Measure-Object).Count
    $extGroups = $tracked | ForEach-Object { [System.IO.Path]::GetExtension($_) } | Where-Object { $_ -match $codeExt } | Group-Object | Sort-Object Count -Descending | Select-Object -First 3
    $obj.topExtensions = ($extGroups | ForEach-Object { "$($_.Name):$($_.Count)" }) -join ','
    $obj.lastModified = $obj.lastCommitDate
  } else {
    $files = Get-ChildItem -Path $p -Recurse -Depth 2 -File -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch 'node_modules|\.venv|__pycache__|build\\|dist\\' } | Select-Object -First 800
    $obj.fileCount = ($files | Measure-Object).Count
    $obj.lastModified = if ($obj.fileCount -gt 0) { ($files | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime.ToString('yyyy-MM-dd') } else { $null }
    $extGroups = $files | Group-Object Extension | Where-Object { $_.Name -match $codeExt } | Sort-Object Count -Descending | Select-Object -First 3
    $obj.topExtensions = ($extGroups | ForEach-Object { "$($_.Name):$($_.Count)" }) -join ','
  }
  # README / docs signal
  $obj.hasReadme = [bool](Get-ChildItem -Path $p -Filter 'README*' -ErrorAction SilentlyContinue | Select-Object -First 1)
  $results += [pscustomobject]$obj
}
$out = "D:\project-dashboard\vibe-dashboard\scan-batch-$Start.json"
$results | ConvertTo-Json -Depth 3 | Out-File $out -Encoding utf8
Write-Output "BATCH ${Start}-${End} DONE: $($results.Count)"
