---
id: task-022
title: Implement hotkeys to move windows between workspaces
status: Done
assignee: []
created_date: '2025-11-26 20:29'
updated_date: '2025-11-26 22:36'
labels: []
dependencies: []
priority: medium
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Implement hotkey bindings that allow moving a single window from one workspace to another workspace. This should provide a smooth workflow for reorganizing windows across workspaces without switching the current view.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Decision: Keeping existing behavior with movetoworkspace (which follows the window to the destination workspace). The current implementation already provides hotkeys to move windows between workspaces using $mod SHIFT + number keys, and we prefer to keep the behavior of following the window to maintain context.
<!-- SECTION:NOTES:END -->
