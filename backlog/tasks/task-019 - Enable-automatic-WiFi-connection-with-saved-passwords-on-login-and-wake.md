---
id: task-019
title: Enable automatic WiFi connection with saved passwords on login and wake
status: In Progress
assignee: []
created_date: '2025-11-15 17:31'
updated_date: '2025-11-15 17:31'
labels: []
dependencies: []
priority: medium
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Currently, NetworkManager attempts to connect to WiFi on login and after wake from sleep, but presents a password dialog that must be filled in manually each time. This is annoying and defeats the purpose of automatic connection.

The desired behavior is:
- WiFi password is stored securely 
- WiFi connects automatically on login without prompting
- WiFi reconnects automatically after waking from sleep without prompting
- Password is reused from storage without user interaction

This likely involves configuring NetworkManager in the NixOS configuration to enable password storage (possibly via GNOME Keyring or similar) and auto-connect settings at the connection level.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 WiFi connects automatically on system login without password prompt
- [ ] #2 WiFi reconnects automatically after waking from sleep without password prompt
- [ ] #3 WiFi password is stored securely and reused across connections
- [ ] #4 No manual password entry required for routine WiFi connections
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
## Investigation Phase
1. Review current NixOS network configuration
2. Check NetworkManager settings and KDE Plasma integration
3. Verify GNOME Keyring or credential storage setup
4. Identify any existing auto-connect configurations

## Configuration Phase
1. Enable credential storage in NetworkManager
2. Configure auto-connect settings for WiFi connections
3. Ensure proper integration with KDE Plasma secret storage
4. Test automatic connection on login
5. Test automatic reconnection after wake from sleep

## Validation Phase
1. Verify password is stored securely
2. Confirm no password prompts appear on login
3. Confirm no password prompts appear after wake
4. Document any required manual WiFi profile changes
<!-- SECTION:PLAN:END -->
