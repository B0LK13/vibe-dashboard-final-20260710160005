# Master Backlog — Vibe Coders Portfolio

Generated 2026-07-14 11:30 from `scan-data.json` (126-project scan, merged 2026-07-14). This is a **telemetry-based** backlog: every item below is inferred from git/filesystem signals (commit hygiene, activity dates, README presence, tech-stack detection) — it is not a source-code review, since this tool doesn't have file access to the other 125 repos. Tech-stack suggestions are generic best-practice recommendations for the detected stack, not code-specific findings.

**290 tasks** across **126 projects**. Full machine-readable database: [`tasks.json`](tasks.json). Per-project detail: `backlog/<project-slug>.md`.

## Summary

| Priority | Count |
|---|---|
| Critical | 5 |
| High | 15 |
| Medium | 90 |
| Low | 180 |

| Category | Count |
|---|---|
| Hygiene | 77 |
| Feature | 71 |
| Lifecycle | 69 |
| Tech-debt | 55 |
| Documentation | 9 |
| Inventory | 8 |
| Data quality | 1 |

## Critical & High priority — act on these first

| ID | Priority | Project | Task |
|---|---|---|---|
| T-0070 | Critical | [AI-shell](F__development_development-agents_ai-shell_AI-shell.md) | Commit or clean up 55 pending change(s) |
| T-0056 | Critical | [development-agents](F__development_development-agents.md) | Commit or clean up 55 pending change(s) |
| T-0172 | Critical | [mda-cli-v2](F__development_development-projects_note-processing-projects_mda-cli-v2.md) | Commit or clean up 55 pending change(s) |
| T-0156 | Critical | [powerplatform-cli-wrapper](F__development_development-projects_microsoft-projects_powerplatform-cli-wrapper.md) | Commit or clean up 95 pending change(s) |
| T-0160 | Critical | [sharepoint-automation](F__development_development-projects_microsoft-projects_sharepoint-automation.md) | Commit or clean up 55 pending change(s) |
| T-0051 | High | [B0LK13s-dark-factory](F__development_B0LK13s-dark-factory.md) | Commit or clean up 17 pending change(s) |
| T-0047 | High | [HelloVerify](D__Projects_HelloVerify.md) | Initialize git version control |
| T-0029 | High | [ados](D__fable5_ados.md) | Initialize git version control |
| T-0004 | High | [ai-fintech](D__ai-fintech.md) | Commit or clean up 12 pending change(s) |
| T-0127 | High | [android-command-center](F__development_development-local_android-command-center.md) | Initialize git version control |
| T-0026 | High | [black-agency-web-design](D__black-agency-web-design.md) | Initialize git version control |
| T-0126 | High | [development-local](F__development_development-local.md) | Initialize git version control |
| T-0046 | High | [flutter_verify](D__Projects_flutter_verify.md) | Initialize git version control |
| T-0035 | High | [manus-llm-chat-exporter](D__manus-llm-chat-exporter.md) | Initialize git version control |
| T-0164 | High | [mda-cli](F__development_development-projects_note-processing-projects_mda-cli.md) | Commit or clean up 10 pending change(s) |
| T-0036 | High | [nexus-macos](D__nexus-macos.md) | Initialize git version control |
| T-0037 | High | [obsidian-plugin](D__obsidian-plugin.md) | Initialize git version control |
| T-0041 | High | [project-llm-wiki](D__project-llm-wiki.md) | Commit or clean up 25 pending change(s) |
| T-0043 | High | [project-llm-wiki](D__project-llm-wiki.md) | Rescan needed — previous scan crashed on this project |
| T-0133 | High | [windows-optimization](F__development_development-local_windows-optimization.md) | Initialize git version control |

## Portfolio-wide findings

- **35 real projects have no git repo at all** — highest-leverage fix across the portfolio, since it's the difference between having history/backup or not: [black-agency-web-design](D__black-agency-web-design.md), [ados](D__fable5_ados.md), [huggingface-downloader](D__huggingface-downloader.md), [manus-llm-chat-exporter](D__manus-llm-chat-exporter.md), [nexus-macos](D__nexus-macos.md), [obsidian-plugin](D__obsidian-plugin.md), [flutter_verify](D__Projects_flutter_verify.md), [HelloVerify](D__Projects_HelloVerify.md), [Chrome Extension for LLM Response Clipping to Obsidian](E__Chrome_Extension_for_LLM_Response_Clipping_to_Obsidian.md), [cloudbase-mcp](F__cloudbase-mcp.md), [obsidian-agent](F__development_bun_obsidian-agent.md), [creator-kit-app](F__development_development-apps_creator-kit-app.md), [fast-api-app](F__development_development-apps_fast-api-app.md), [cloud-dashboard](F__development_development-cloud_cloud-dashboard.md), [WebView2Demo](F__development_development-demos_WebView2Demo.md), [development-local](F__development_development-local.md), [android-command-center](F__development_development-local_android-command-center.md), [bootstrap-workstation](F__development_development-local_bootstrap-workstation.md), [file-management-tool](F__development_development-local_file-management-tool.md), [windows-optimization](F__development_development-local_windows-optimization.md), [development-notes](F__development_development-notes.md), [hello-ai](F__development_development-projects_hello-ai.md), [my-fastapi-app](F__development_development-projects_my-fastapi-app.md), [scripting-json](F__development_development-scripting_scripting-json.md), [scripting-powershell](F__development_development-scripting_scripting-powershell.md), [scripting-python](F__development_development-scripting_scripting-python.md), [deepsite_projects](F__development_development-webpages_deepsite_projects.md), [gas-showcase-platform](F__development_development-webpages_gas-showcase-platform.md), [gcp](F__development_development-webpages_gcp.md), [gemini-created-webpages](F__development_development-webpages_gemini-created-webpages.md), [productivity-manager-extension](F__development_productivity-manager-extension.md), [pipelines](F__pipelines.md), [project-os-genx](F__project-os-genx.md), [src](F__src.md), [vibe-dev](F__vibe-dev.md).

- **4 scan entries point to paths that no longer exist**: `C:\Users\Admin\Documents\antigravity\fervent-franklin`, `C:\Users\Admin\StudioProjects\black-agency-os-android`, `C:\Users\Admin\StudioProjects\stoic-journal`, `E:\PowerShell\Source\M365FoundationsCISReport`. Clean up `scan.ps1`'s project list or confirm these were intentionally moved/removed.

- **2 vendor clones** (`flutter`, `homebrew`) inflate the dashboard's commit/contributor charts by orders of magnitude over any real project. Tag them and exclude from active-portfolio scoring (tracked as a Known Limit in the dashboard's own README already).

- **20 projects have had zero activity in over a year**, **32 more in the last 6–12 months.** Worth a single triage pass: archive what's truly done, delete what was abandoned, and note a next milestone for anything you intend to revive.

- **7 project names appear more than once** at different paths — likely duplicate clones/copies worth consolidating or clearly distinguishing:
  - **M365FoundationsCISReport** — `E:\PowerShell\Source\M365FoundationsCISReport`; `F:\development\PowerShell\Source\M365FoundationsCISReport`
  - **black-agency-os-android** — `C:\Users\Admin\StudioProjects\black-agency-os-android`; `D:\AndroidProjects\black-agency-os-android`
  - **mda-cli** — `F:\development\development-projects\note-processing-projects\mda-cli`; `F:\mda-cli`
  - **mda-cross-platform** — `F:\development\development-projects\vibe-coding-apps\mda-cross-platform`; `F:\mda-cross-platform`
  - **obsidian-agent** — `F:\development\bun\obsidian-agent`; `F:\development\development-agents\ai-agents\obsidian-agent`
  - **stoic-journal** — `C:\Users\Admin\StudioProjects\stoic-journal`; `D:\AndroidProjects\stoic-journal`; `F:\development\projects\stoic-journal`
  - **template-android-app** — `D:\AndroidProjects\template-android-app`; `F:\development\template-android-app`

- **16 projects under `development-webpages`** look like near-identical thin scaffolds (single `.html`/`.css`/`.md`, ≤5 commits, all from 2025) — likely early experiments or generator output. Worth a batch pass: keep the ones still relevant, archive the rest as a group instead of tracking each individually.

- **8 projects under `dashboards`** show the same thin-scaffold pattern (single-purpose HTML dashboards, ≤5 commits each) — same consolidate-or-archive candidate as above.

- **The dashboard tool itself** (`vibe-dashboard`) is tracked in this scan too — see its own `README.md` History section for its detailed engineering log rather than this generic backlog format.

## All projects, by category

### 10-security (3)

- [intelligence_report](F__development_development-security_10-security_intelligence_report.md) — 3 task(s)
- [operational_security](F__development_development-security_10-security_operational_security.md) — 3 task(s)
- [security_portal](F__development_development-security_10-security_security_portal.md) — 2 task(s)

### Agents (1)

- [hermes-agent](F__development_development-agents_Agents_hermes-agent.md) — 4 task(s)

### AndroidProjects (6)

- [black-agency-os-android](D__AndroidProjects_black-agency-os-android.md) — 3 task(s)
- [daily-trendscape](D__AndroidProjects_daily-trendscape.md) — 2 task(s)
- [project-pulse-android](D__AndroidProjects_project-pulse-android.md) — 2 task(s)
- [stoic-journal](D__AndroidProjects_stoic-journal.md) — 3 task(s)
- [template-android-app](D__AndroidProjects_template-android-app.md) — 2 task(s)
- [vibe-dashboard-android](D__AndroidProjects_vibe-dashboard-android.md) — 3 task(s)

### D-root (10)

- [ai-fintech](D__ai-fintech.md) — 4 task(s)
- [autonomous-loop](D__autonomous-loop.md) — 3 task(s)
- [black-agency-web-design](D__black-agency-web-design.md) — 1 task(s)
- [cursor-optimization-project](D__cursor-optimization-project.md) — 2 task(s)
- [flutter](D__flutter.md) _(vendor)_ — 2 task(s)
- [huggingface-downloader](D__huggingface-downloader.md) — 1 task(s)
- [manus-llm-chat-exporter](D__manus-llm-chat-exporter.md) — 1 task(s)
- [nexus-macos](D__nexus-macos.md) — 1 task(s)
- [obsidian-plugin](D__obsidian-plugin.md) — 1 task(s)
- [project-llm-wiki](D__project-llm-wiki.md) — 5 task(s)

### E-root (1)

- [Chrome Extension for LLM Response Clipping to Obsidian](E__Chrome_Extension_for_LLM_Response_Clipping_to_Obsidian.md) — 1 task(s)

### F-root (7)

- [cloudbase-mcp](F__cloudbase-mcp.md) — 1 task(s)
- [mda-cli](F__mda-cli.md) — 3 task(s)
- [mda-cross-platform](F__mda-cross-platform.md) — 3 task(s)
- [pipelines](F__pipelines.md) — 2 task(s)
- [project-os-genx](F__project-os-genx.md) — 2 task(s)
- [src](F__src.md) — 2 task(s)
- [vibe-dev](F__vibe-dev.md) — 1 task(s)

### Projects (2)

- [flutter_verify](D__Projects_flutter_verify.md) — 1 task(s)
- [HelloVerify](D__Projects_HelloVerify.md) — 1 task(s)

### Source (2)

- [M365FoundationsCISReport](E__PowerShell_Source_M365FoundationsCISReport.md) _(missing)_ — 1 task(s)
- [M365FoundationsCISReport](F__development_PowerShell_Source_M365FoundationsCISReport.md) — 3 task(s)

### StudioProjects (2)

- [black-agency-os-android](C__Users_Admin_StudioProjects_black-agency-os-android.md) _(missing)_ — 1 task(s)
- [stoic-journal](C__Users_Admin_StudioProjects_stoic-journal.md) _(missing)_ — 1 task(s)

### ai-agents (1)

- [obsidian-agent](F__development_development-agents_ai-agents_obsidian-agent.md) — 3 task(s)

### ai-shell (2)

- [AI-shell](F__development_development-agents_ai-shell_AI-shell.md) — 3 task(s)
- [AIShell](F__development_development-agents_ai-shell_AIShell.md) — 3 task(s)

### antigravity (1)

- [fervent-franklin](C__Users_Admin_Documents_antigravity_fervent-franklin.md) _(missing)_ — 1 task(s)

### automation (1)

- [crawl-for-ai-rag](F__development_development-projects_automation_crawl-for-ai-rag.md) — 3 task(s)

### bun (1)

- [obsidian-agent](F__development_bun_obsidian-agent.md) — 2 task(s)

### chrome-extensies (2)

- [finance_tracker](F__development_development-projects_chrome-extensies_finance_tracker.md) — 2 task(s)
- [mermaid_diagram_editor](F__development_development-projects_chrome-extensies_mermaid_diagram_editor.md) — 3 task(s)

### cloud-development-google (1)

- [gcp-cli](F__development_development-cloud_cloud-development-google_gcp-cli.md) — 2 task(s)

### cloud-development-microsoft (1)

- [sharepoint-ssot-mcp](F__development_development-cloud_cloud-development-microsoft_sharepoint-ssot-mcp.md) — 3 task(s)

### cloud-hostinger (1)

- [vps-cli](F__development_development-cloud_cloud-hostinger_vps-cli.md) — 3 task(s)

### cloud-infra (1)

- [proxmox_development](F__development_development-cloud_cloud-infra_proxmox_development.md) — 3 task(s)

### dashboards (8)

- [cloud_dashboard](F__development_development-dashboards_dashboards_cloud_dashboard.md) — 4 task(s)
- [cloudflare_dashboard](F__development_development-dashboards_dashboards_cloudflare_dashboard.md) — 3 task(s)
- [email_intel_dashboard](F__development_development-dashboards_dashboards_email_intel_dashboard.md) — 2 task(s)
- [file_dashboard](F__development_development-dashboards_dashboards_file_dashboard.md) — 2 task(s)
- [huisvesting_dashboard](F__development_development-dashboards_dashboards_huisvesting_dashboard.md) — 2 task(s)
- [status-dashboard](F__development_development-dashboards_dashboards_status-dashboard.md) — 3 task(s)
- [tech_analyse_dashboard](F__development_development-dashboards_dashboards_tech_analyse_dashboard.md) — 1 task(s)
- [trading_dashboard](F__development_development-dashboards_dashboards_trading_dashboard.md) — 3 task(s)

### development (8)

- [B0LK13s-dark-factory](F__development_B0LK13s-dark-factory.md) — 3 task(s)
- [development-agents](F__development_development-agents.md) — 2 task(s)
- [development-local](F__development_development-local.md) — 1 task(s)
- [development-notes](F__development_development-notes.md) — 1 task(s)
- [dotfiles](F__development_dotfiles.md) — 2 task(s)
- [productivity-manager-extension](F__development_productivity-manager-extension.md) — 2 task(s)
- [template-android-app](F__development_template-android-app.md) — 2 task(s)
- [template-compose-stack](F__development_template-compose-stack.md) — 1 task(s)

### development-agents (1)

- [Agents](F__development_development-agents_Agents.md) — 2 task(s)

### development-apps (4)

- [creator-kit-app](F__development_development-apps_creator-kit-app.md) — 1 task(s)
- [euro_subtracker](F__development_development-apps_euro_subtracker.md) — 5 task(s)
- [EuroSubTrackerPro](F__development_development-apps_EuroSubTrackerPro.md) — 4 task(s)
- [fast-api-app](F__development_development-apps_fast-api-app.md) — 1 task(s)

### development-authenticatie (1)

- [GithubAcces](F__development_development-authenticatie_GithubAcces.md) — 2 task(s)

### development-automation (1)

- [autoresearch-loop](F__development_development-automation_autoresearch-loop.md) — 1 task(s)

### development-cloud (2)

- [cloud-dashboard](F__development_development-cloud_cloud-dashboard.md) — 1 task(s)
- [multi-environment](F__development_development-cloud_multi-environment.md) — 3 task(s)

### development-demos (2)

- [docker-scout-demo-service](F__development_development-demos_docker-scout-demo-service.md) — 3 task(s)
- [WebView2Demo](F__development_development-demos_WebView2Demo.md) — 1 task(s)

### development-local (5)

- [android-command-center](F__development_development-local_android-command-center.md) — 1 task(s)
- [bootstrap-workstation](F__development_development-local_bootstrap-workstation.md) — 1 task(s)
- [file-management-tool](F__development_development-local_file-management-tool.md) — 1 task(s)
- [local-ai-packaged](F__development_development-local_local-ai-packaged.md) — 3 task(s)
- [windows-optimization](F__development_development-local_windows-optimization.md) — 1 task(s)

### development-management (1)

- [ip-address-management-ipam](F__development_development-management_ip-address-management-ipam.md) — 3 task(s)

### development-projects (8)

- [context-engineering-intro](F__development_development-projects_context-engineering-intro.md) — 3 task(s)
- [hello-ai](F__development_development-projects_hello-ai.md) — 2 task(s)
- [inbox_zen](F__development_development-projects_inbox_zen.md) — 3 task(s)
- [my-fastapi-app](F__development_development-projects_my-fastapi-app.md) — 1 task(s)
- [open-deep-research](F__development_development-projects_open-deep-research.md) — 3 task(s)
- [self-hosted-ai-starter-kit](F__development_development-projects_self-hosted-ai-starter-kit.md) — 2 task(s)
- [self-hosted-ai-starter-kit2](F__development_development-projects_self-hosted-ai-starter-kit2.md) — 3 task(s)
- [youtube-generator](F__development_development-projects_youtube-generator.md) — 3 task(s)

### development-scripting (3)

- [scripting-json](F__development_development-scripting_scripting-json.md) — 2 task(s)
- [scripting-powershell](F__development_development-scripting_scripting-powershell.md) — 1 task(s)
- [scripting-python](F__development_development-scripting_scripting-python.md) — 2 task(s)

### development-software-and-tools (1)

- [homebrew](F__development_development-software-and-tools_homebrew.md) _(vendor)_ — 2 task(s)

### development-webpages (21)

- [cyber-command-center](F__development_development-webpages_cyber-command-center.md) — 2 task(s)
- [cyber_warfare_group](F__development_development-webpages_cyber_warfare_group.md) — 3 task(s)
- [deepsite_projects](F__development_development-webpages_deepsite_projects.md) — 2 task(s)
- [digital_architect](F__development_development-webpages_digital_architect.md) — 3 task(s)
- [digital_CV](F__development_development-webpages_digital_CV.md) — 2 task(s)
- [digital_mandate](F__development_development-webpages_digital_mandate.md) — 3 task(s)
- [docu_core](F__development_development-webpages_docu_core.md) — 3 task(s)
- [gas-showcase-platform](F__development_development-webpages_gas-showcase-platform.md) — 2 task(s)
- [gcp](F__development_development-webpages_gcp.md) — 1 task(s)
- [gemini-created-webpages](F__development_development-webpages_gemini-created-webpages.md) — 2 task(s)
- [hapi_interactive_manual](F__development_development-webpages_hapi_interactive_manual.md) — 3 task(s)
- [huggingface_spaces](F__development_development-webpages_huggingface_spaces.md) — 2 task(s)
- [nullsector](F__development_development-webpages_nullsector.md) — 3 task(s)
- [omega_secure](F__development_development-webpages_omega_secure.md) — 3 task(s)
- [rag_chat](F__development_development-webpages_rag_chat.md) — 3 task(s)
- [rootweb3.0](F__development_development-webpages_rootweb3.0.md) — 3 task(s)
- [social_spark](F__development_development-webpages_social_spark.md) — 3 task(s)
- [stormcommando](F__development_development-webpages_stormcommando.md) — 3 task(s)
- [technomad](F__development_development-webpages_technomad.md) — 2 task(s)
- [terminal_chat](F__development_development-webpages_terminal_chat.md) — 3 task(s)
- [the_modern_survival_,manual](F__development_development-webpages_the_modern_survival_,manual.md) — 3 task(s)

### document-processing-projects (1)

- [automated_document_hub](F__development_development-projects_document-processing-projects_automated_document_hub.md) — 2 task(s)

### fable5 (2)

- [ados](D__fable5_ados.md) — 1 task(s)
- [black-agency-os](D__fable5_black-agency-os.md) — 2 task(s)

### microsoft-projects (2)

- [powerplatform-cli-wrapper](F__development_development-projects_microsoft-projects_powerplatform-cli-wrapper.md) — 4 task(s)
- [sharepoint-automation](F__development_development-projects_microsoft-projects_sharepoint-automation.md) — 3 task(s)

### note-processing-projects (4)

- [mda-cli](F__development_development-projects_note-processing-projects_mda-cli.md) — 4 task(s)
- [mda-cli-new](F__development_development-projects_note-processing-projects_mda-cli-new.md) — 4 task(s)
- [mda-cli-v2](F__development_development-projects_note-processing-projects_mda-cli-v2.md) — 2 task(s)
- [obsidian-nexus](F__development_development-projects_note-processing-projects_obsidian-nexus.md) — 3 task(s)

### project-dashboard (1)

- [vibe-dashboard](D__project-dashboard_vibe-dashboard.md) — 3 task(s)

### projects (1)

- [stoic-journal](F__development_projects_stoic-journal.md) — 3 task(s)

### vibe-coding-apps (3)

- [citation-cleanup-tui](F__development_development-projects_vibe-coding-apps_citation-cleanup-tui.md) — 3 task(s)
- [mda-cross-platform](F__development_development-projects_vibe-coding-apps_mda-cross-platform.md) — 2 task(s)
- [vibed-dev-env](F__development_development-projects_vibe-coding-apps_vibed-dev-env.md) — 3 task(s)

