---
id: task-021
title: Research tiling window manager best practices for handling minimized windows
status: In Progress
assignee: []
created_date: '2025-11-26 20:29'
updated_date: '2025-11-26 21:18'
labels: []
dependencies: []
priority: medium
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Research how tiling window managers recommend dealing with windows that would normally get minimized. This includes investigating common patterns, community recommendations, and alternative approaches to window minimization in tiling environments.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Research Findings: Hyprland Minimize Behavior

**Context**: This system uses Hyprland as the window manager.

### Key Finding: No Native Minimize in Hyprland
Hyprland does NOT have a built-in minimize dispatcher. The tiling window manager philosophy actively discourages minimizing windows.

### Tiling WM Philosophy on Minimization
1. **Close Instead of Minimize**: Tiling WMs encourage closing unused applications rather than minimizing them
2. **Always Visible**: Each open window should remain visible through efficient layouts
3. **Workspace Organization**: Multiple workspaces are the preferred method for organizing windows
4. **Keyboard-Driven**: Focus on keyboard shortcuts for quick workspace/window navigation

### Hyprland-Specific Alternatives to Minimize

#### 1. Special Workspaces (Scratchpads)
- **What**: Floating workspace overlays that can be toggled on/off on any monitor
- **Similar to**: i3wm scratchpads
- **Usage**:
  - Move window: `movetoworkspace, special` or `movetoworkspace, special:name`
  - Toggle visibility: `togglespecialworkspace` or `togglespecialworkspace, name`
  - Can define up to 97 named special workspaces

**Configuration Example**:
```
bind = SUPER, C, movetoworkspace, special
bind = ALT, X, togglespecialworkspace
```

**Window Rules Approach**:
- Set apps to always launch in special workspace
- Increase outer gaps (e.g., 30px) for visual distinction

#### 2. Silent Workspace Movement
- **Dispatcher**: `movetoworkspacesilent`
- **Function**: Moves window to another workspace without switching view
- **Effect**: Effectively hides window from current view
- **Usage**: `movetoworkspacesilent, workspace_number`

#### 3. Community Tools
- **hpr-scratcher**: JSON-configurable scratchpad manager with custom animations
- **hyprscratch**: Makes scratchpads part of current workspace by default
- Custom scripts for traditional scratchpad behavior

### Recommendations for This System

1. **Implement Special Workspaces**: Configure named special workspaces for common "minimize" use cases
2. **Keybindings**: Set up intuitive shortcuts for:
   - Moving windows to special workspace
   - Toggling special workspace visibility
   - Silent workspace movement
3. **User Workflow Shift**: Train users to:
   - Close unused applications
   - Use workspaces for organization
   - Use special workspaces for temporary hiding
4. **Window Rules**: Configure specific apps (like system monitors, terminals) to launch in special workspaces

### Known Limitations
- No explicit show/hide (only toggle)
- Hidden special workspace windows can be focused inadvertently
- Special workspaces may conflict with fullscreen windows
<!-- SECTION:NOTES:END -->
