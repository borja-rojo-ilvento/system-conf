---
id: task-018
title: Resolve GTK configuration file conflicts in Home Manager
status: To Do
assignee: []
created_date: '2025-11-15 16:47'
labels: []
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Home Manager is failing to activate because it's trying to clobber existing GTK configuration files:
- /home/brojo/.gtkrc-2.0
- /home/brojo/.config/gtk-4.0/gtk.css
- /home/brojo/.config/gtk-4.0/settings.ini
- /home/brojo/.config/gtk-3.0/gtk.css
- /home/brojo/.config/gtk-3.0/settings.ini

These files are managed by Home Manager configurations that need to be removed or consolidated. The approach is to:
1. Identify and remove the conflicting configurations from the codebase
2. Generate expected configuration files in a new `new_config/` directory at the root showing what should be manually placed
<!-- SECTION:DESCRIPTION:END -->
