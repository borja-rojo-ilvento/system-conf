---
id: task-020
title: Optimize ghostty startup performance
status: In Progress
assignee: []
created_date: '2025-11-15 22:32'
updated_date: '2025-11-15 22:32'
labels:
  - ghostty
  - performance
  - systemd
dependencies: []
priority: medium
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Configure ghostty to launch faster by leveraging background service initialization and systemd single-instance mode.

## Context
Ghostty's initial startup can be optimized by running a background service at login, which pre-initializes the application. Subsequent window launches benefit from the single-instance mode (`gtk-single-instance` setting).

From https://github.com/ghostty-org/ghostty/discussions/8475:
- Initial window startup time is around 300-500ms and unavoidable
- Subsequent windows launched from a background service are significantly faster
- Systemd service files are available in Nix builds at `~/.config/systemd/user/app-com.mitchellh.ghostty.service`
- System power profiles (e.g., power-saver vs balanced) can affect perceived startup time

## Approach
1. Enable the ghostty systemd service to auto-start at login
2. Verify single-instance mode is properly configured
3. Test and measure startup time improvements
4. Document the configuration in home configuration
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Ghostty systemd user service is enabled and auto-starts at login
- [ ] #2 Single-instance mode is configured and verified working
- [ ] #3 Measured startup time for subsequent windows (should be < 100ms)
- [ ] #4 Configuration is properly documented and reproducible via home-manager
- [ ] #5 Verify service file location and status via systemctl --user
<!-- AC:END -->
