---
id: task-019
title: Enable automatic WiFi connection with saved passwords on login and wake
status: To Do
assignee: []
created_date: '2025-11-15 17:31'
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
