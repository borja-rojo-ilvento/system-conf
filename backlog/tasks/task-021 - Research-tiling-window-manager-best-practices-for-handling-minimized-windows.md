---
id: task-021
title: Research tiling window manager best practices for handling minimized windows
status: Done
assignee: []
created_date: '2025-11-26 20:29'
updated_date: '2025-11-26 21:27'
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

## Zoom-Specific Window Management Solutions

### The Zoom Problem in Tiling WMs

Zoom creates multiple windows that are invasive for tiling window managers:
1. **Main app window**: Navigation menus and agenda information
2. **Meeting window**: Separate popup for actual meetings
3. **Notification popups**: "Informative" popups that steal focus
4. **Menu/toolbar windows**: Various UI elements as separate windows

### Community Solutions

#### Basic Approach: Float All Zoom Windows
```
windowrulev2 = float,class:(^zoom$)
windowrulev2 = center,class:(^zoom$)
```

#### Advanced: Target Specific Zoom Windows

Zoom windows identified via `hyprctl clients`:
- **class**: `zoom` (lowercase)
- **Common titles**: 
  - `menu window` - popup menus
  - `confirm window` - confirmation dialogs
  - `Zoom Meeting` - meeting windows
  - Various notification windows

**Selective Rules Example**:
```
# Float meeting windows
windowrulev2 = float,class:(^zoom$),title:(Zoom Meeting)

# Float and don't focus notification popups
windowrulev2 = float,class:(^zoom$),title:(^zoom\s?$)
windowrulev2 = nofocus,class:(^zoom$),title:(^zoom\s?$)
```

#### Solutions from i3/Sway Users

From i3 config (similar principles apply to Hyprland):
```
# Set Zoom notification window to floating with no focus
for_window [title="^zoom\\s?$"] floating enable
no_focus [title="^zoom\\s?$"]
```

Some users implement scripts to **instantly kill** notification popups so they never disturb workflow.

### Investigation Steps for This System

1. **Run Zoom and inspect windows**:
   ```bash
   hyprctl clients
   ```
   Document all class/title combinations

2. **Identify which windows need floating**:
   - Main app window: Possibly tile or float?
   - Meeting window: Likely float + center
   - Notification popups: Float + nofocus or kill

3. **Configure window rules** based on findings

4. **Test workflow** and refine rules

### Additional Considerations

- **XWayland**: Zoom runs via XWayland (xwayland: 1)
- **Screen sharing**: Requires additional Hyprland configuration (xdg-desktop-portal-hyprland)
- **Workspace behavior**: Zoom doesn't work well with virtual workspaces - windows may disappear when switching
- **Static vs dynamic rules**: Use `initialClass` and `initialTitle` for static rules that apply at window creation

### Recommended Next Steps

1. Install/configure Zoom if not already done
2. Run Zoom and capture window properties with `hyprctl clients`
3. Create targeted window rules for each Zoom window type
4. Consider creating a separate task for implementing the Zoom window rules
<!-- SECTION:NOTES:END -->
