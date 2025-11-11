---
id: task-002
title: 'Phase 1: Core Services Foundation'
status: Done
assignee: []
created_date: '2025-11-11 01:01'
labels: []
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Enable and configure essential system services for Hyprland: D-Bus, notification daemon, polkit agent, and XDG Desktop Portal
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 D-Bus session management verified and functional
- [ ] #2 Notification daemon (dunst) installed and configured
- [ ] #3 hyprpolkitagent installed and operational
- [ ] #4 xdg-desktop-portal and xdg-desktop-portal-hyprland configured
- [ ] #5 All services verified to start correctly on boot
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
Enable Hyprland via NixOS module; Configure D-Bus; Install dunst; Install hyprpolkitagent; Setup XDG portals; Verify service startup
<!-- SECTION:PLAN:END -->
