---
id: task-024
title: Remove global transparency rules for Firefox and other apps
status: Done
assignee: []
created_date: '2025-11-26 20:29'
updated_date: '2025-11-26 22:58'
labels: []
dependencies: []
priority: medium
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Remove system-level transparency configuration for Firefox and other applications. Transparency should be controlled by the applications themselves so they can manage transparency behavior appropriately (e.g., keeping text opaque while backgrounds are transparent).
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Removed the opacity rule from lib/users/brojo/programs/hyprland/default.nix:142. Firefox will now control its own transparency settings instead of having a system-level 0.95 opacity override applied.
<!-- SECTION:NOTES:END -->
