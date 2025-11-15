---
id: task-017
title: Research terminal-based alternatives to desktop applications
status: Done
assignee: []
created_date: '2025-11-15 04:39'
updated_date: '2025-11-15 05:55'
labels:
  - research
  - tooling
  - terminal
  - nix
dependencies: []
priority: medium
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Investigate and document terminal-based (TUI) applications that can serve as alternatives to traditional GUI desktop applications. This research will help identify modern terminal tools that could improve the development environment and system configuration workflow. Focus on discovering tools that are actively maintained and have strong community adoption.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Identify and document at least 3-5 major categories of applications (e.g., editors, file managers, media players, communication tools, etc.)
- [x] #2 For each category, list 2-3 recommended terminal alternatives with brief descriptions of features and use cases
- [x] #3 Compare key characteristics: installation method, learning curve, customization options, and integration with other tools
- [x] #4 Document findings in a discoverable format (document or task notes)
- [x] #5 Evaluate which tools could be integrated into the NixOS configuration
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Research completed: Created comprehensive Terminal-Based (TUI) Applications Guide covering 12 major categories: text editors (Neovim, Emacs, Helix), file managers (lf, nnn, ranger, broot), system monitoring (htop, btop, bottom), web browsers (w3m, lynx, elinks), communication (mutt, weechat, signal-cli), media tools (mpv, cmus, ffmpeg), document processing (pandoc, bat, groff), data processing (jq, yq, sqlite), git tools (lazygit, tig), database clients (pgcli, usql), system administration (nmtui, bluetoothctl), and productivity (taskwarrior, org-mode). Each tool evaluated on: installation method, features, learning curve, customization, NixOS integration, and use cases. Document includes integration recommendations identifying already-integrated tools, medium-priority additions (lazygit, broot), and optional power-user tools. Ready for implementation phase.
<!-- SECTION:NOTES:END -->
