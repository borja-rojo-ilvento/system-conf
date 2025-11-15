---
id: doc-001
title: Terminal-Based (TUI) Applications Guide
type: other
created_date: '2025-11-15 05:55'
---
# Terminal-Based (TUI) Applications Guide

A comprehensive research document of modern terminal user interface (TUI) applications as alternatives to traditional GUI desktop applications. This guide evaluates tools by category, comparing features, installation methods, learning curves, and integration potential with NixOS.

## Document Scope
This document covers:
- Core application categories (editors, file managers, media, communication, etc.)
- 2-3 recommended alternatives per category with feature comparisons
- Installation/integration notes for NixOS
- Learning curve assessment
- Use case recommendations

---

## 1. Text Editors & IDEs

### Category Overview
Terminal-based editors have evolved significantly with advanced features like language server protocol (LSP) support, tree-sitter syntax highlighting, and extensive plugin ecosystems.

### 1.1 Neovim
- **Installation**: Available in nixpkgs, already configured in this system
- **Features**: LSP support, treesitter, lua configuration, modal editing
- **Learning Curve**: Medium (vim experience helpful)
- **Customization**: Extensive via lua scripting
- **Integration**: ✓ Already integrated, actively maintained
- **Use Case**: Primary development editor, scriptable configuration

### 1.2 GNU Emacs (emacs-nox)
- **Installation**: `emacs-nox` in nixpkgs (no X11 dependencies)
- **Features**: Lisp configuration, org-mode, email, IRC, full Turing-complete environment
- **Learning Curve**: High (lisp knowledge recommended)
- **Customization**: Extremely extensive
- **Integration**: ✓ Can be added to NixOS config
- **Use Case**: Power users wanting complete environment customization

### 1.3 Helix
- **Installation**: `helix` in nixpkgs
- **Features**: Multi-cursor editing, LSP out-of-box, tree-sitter, modern defaults
- **Learning Curve**: Low-Medium (vim-inspired, more intuitive)
- **Customization**: Moderate (TOML config)
- **Integration**: ✓ Good NixOS support
- **Use Case**: Modern vim alternative with better defaults, less configuration needed

---

## 2. File Managers

### Category Overview
Terminal file managers provide navigation, preview, and batch operations in pure TUI environment.

### 2.1 lf
- **Installation**: `lf` in nixpkgs
- **Features**: Lightweight, shell integration, image preview via preview scripts
- **Learning Curve**: Low (vim-like keybinds)
- **Customization**: Shell scripting
- **Integration**: ✓ Actively maintained, NixOS packages available
- **Use Case**: Minimal file navigation, shell integration

### 2.2 nnn
- **Installation**: `nnn` in nixpkgs
- **Features**: Minimal footprint, bookmarks, plugins, batch operations
- **Learning Curve**: Low (intuitive navigation)
- **Customization**: Plugin system, bash scripting
- **Integration**: ✓ Good NixOS support
- **Use Case**: Quick file exploration, plugin ecosystem

### 2.3 Ranger / broot
- **Installation**: `ranger` or `broot` in nixpkgs
- **Features** (ranger): Python-based, preview window, vi-like commands
- **Features** (broot): Tree view, regex search, directory size analysis
- **Learning Curve**: Low-Medium
- **Customization**: Python/Rust configuration
- **Integration**: ✓ Both available
- **Use Case**: ranger for preview-rich navigation; broot for tree analysis

### Recommendation
- **Minimal setup**: lf or nnn
- **Power users**: ranger with image previews
- **Directory exploration**: broot for tree analysis

---

## 3. System Monitoring & Performance

### Category Overview
Monitor system resources, processes, and performance metrics entirely from terminal.

### 3.1 htop / btop
- **Installation**: Both in nixpkgs (already added to dev tools)
- **Features**: htop is classic (process monitoring); btop is modern with graphs/colors
- **Learning Curve**: Low (intuitive interface)
- **Customization**: Moderate (color schemes, column selection)
- **Integration**: ✓ Both in NixOS
- **Use Case**: System monitoring, process management

### 3.2 bottom (btm)
- **Installation**: `bottom` in nixpkgs (already added)
- **Features**: Disk I/O, network, GPU monitoring with graphs
- **Learning Curve**: Low
- **Customization**: Good (config file)
- **Integration**: ✓ Available in NixOS
- **Use Case**: Comprehensive system monitoring with beautiful layout

### 3.3 iotop / iftop
- **Installation**: Both in nixpkgs
- **Features**: iotop for disk I/O by process; iftop for network bandwidth per connection
- **Learning Curve**: Low
- **Customization**: Minimal (command-line options)
- **Integration**: ✓ Both available
- **Use Case**: Specific monitoring (disk I/O or network)

---

## 4. Web Browsers & Content Viewing

### Category Overview
Limited but growing ecosystem of TUI browsers for specific use cases.

### 4.1 w3m / lynx
- **Installation**: Both in nixpkgs
- **Features**: w3m supports inline images in tmux; lynx is lightweight text-only
- **Learning Curve**: Low (navigation focused)
- **Customization**: Limited
- **Integration**: ✓ Available
- **Use Case**: Documentation viewing, simple web content, terminal image preview

### 4.2 elinks
- **Installation**: `elinks` in nixpkgs
- **Features**: Better HTML rendering than lynx, tabs, history
- **Learning Curve**: Low
- **Customization**: Moderate (config file)
- **Integration**: ✓ Available
- **Use Case**: Terminal web browsing for static content

### 4.3 fzf + Preview Tools
- **Installation**: `fzf` + `bat` or `highlight` (already in config)
- **Features**: Fuzzy search with preview, not a browser but excellent for searching local content
- **Learning Curve**: Low
- **Customization**: Good (shell integration)
- **Integration**: ✓ Already integrated
- **Use Case**: Find and preview files/documentation quickly

---

## 5. Communication & Messaging

### Category Overview
Email, IRC, and chat clients entirely within terminal.

### 5.1 mutt / neomutt
- **Installation**: `neomutt` in nixpkgs
- **Features**: Email client with PGP, MIME, IMAP/SMTP support
- **Learning Curve**: Medium-High (complex configuration)
- **Customization**: Very extensive
- **Integration**: ✓ Available, active development
- **Use Case**: Email power users, plaintext preference

### 5.2 irssi / weechat
- **Installation**: Both in nixpkgs
- **Features**: irssi for IRC; weechat for IRC/XMPP/Slack and more
- **Learning Curve**: Low-Medium
- **Customization**: Good (scripting support)
- **Integration**: ✓ Both available
- **Use Case**: IRC connectivity, weechat for multi-protocol

### 5.3 signal-cli / jq for JSON APIs
- **Installation**: `signal-cli` in nixpkgs
- **Features**: Signal messaging from terminal (no GUI needed)
- **Learning Curve**: Low
- **Customization**: Command-line driven
- **Integration**: ✓ Available
- **Use Case**: Signal users avoiding GUI client

---

## 6. Media Tools & Playback

### Category Overview
Audio/video playback and manipulation entirely in terminal.

### 6.1 mpv (with no-video for audio)
- **Installation**: `mpv` in nixpkgs
- **Features**: Minimal video/audio player, scriptable, excellent for automation
- **Learning Curve**: Low (play files easily)
- **Customization**: Lua scripting possible
- **Integration**: ✓ Available
- **Use Case**: Audio playback, script-based media handling

### 6.2 cmus / ncmpcpp
- **Installation**: Both in nixpkgs
- **Features**: cmus is minimal; ncmpcpp is for Music Player Daemon (MPD) backend
- **Learning Curve**: Low
- **Customization**: Moderate
- **Integration**: ✓ Both available
- **Use Case**: Music playback with playlist management

### 6.3 ffmpeg / sox
- **Installation**: Both in nixpkgs
- **Features**: Audio/video processing, format conversion, effects
- **Learning Curve**: Medium (command-line flags complex)
- **Customization**: Extensive via arguments
- **Integration**: ✓ Both available
- **Use Case**: Batch processing, format conversion, audio engineering

---

## 7. Document & Text Processing

### Category Overview
View, convert, and process documents without GUI applications.

### 7.1 pandoc
- **Installation**: `pandoc` in nixpkgs (already in config)
- **Features**: Universal document converter (markdown, docx, pdf, etc.)
- **Learning Curve**: Low
- **Customization**: Good (templates, lua filters)
- **Integration**: ✓ Already configured
- **Use Case**: Document format conversion, template-based generation

### 7.2 less / more / bat
- **Installation**: `bat` in nixpkgs (already in config - cat replacement)
- **Features**: bat provides syntax highlighting; less provides scrollable viewing
- **Learning Curve**: Low
- **Customization**: Moderate (themes)
- **Integration**: ✓ Already configured (bat)
- **Use Case**: Code/log viewing with highlights

### 7.3 groff / mandoc
- **Installation**: `groff` in nixpkgs
- **Features**: Manual page formatting, document layout
- **Learning Curve**: High (complex markup)
- **Customization**: Extensive
- **Integration**: ✓ Available
- **Use Case**: Technical documentation, man page generation

---

## 8. JSON/Data Processing

### Category Overview
Query, transform, and visualize structured data.

### 8.1 jq
- **Installation**: `jq` in nixpkgs (already configured)
- **Features**: JSON query language, filtering, transformation
- **Learning Curve**: Low-Medium (powerful but simple syntax)
- **Customization**: Query-based
- **Integration**: ✓ Already configured
- **Use Case**: API response parsing, JSON manipulation

### 8.2 yq
- **Installation**: `yq` in nixpkgs (already configured)
- **Features**: YAML/XML/JSON processor (jq for YAML)
- **Learning Curve**: Low-Medium (similar to jq)
- **Customization**: Query-based
- **Integration**: ✓ Already configured
- **Use Case**: Config file manipulation, multi-format processing

### 8.3 sqlite3
- **Installation**: `sqlite` in nixpkgs (already configured)
- **Features**: SQL database in terminal, query structured data
- **Learning Curve**: Medium (SQL knowledge required)
- **Customization**: SQL-based
- **Integration**: ✓ Already configured
- **Use Case**: Querying relational data, data analysis

---

## 9. Git & Version Control

### Category Overview
Git operations entirely from terminal (beyond standard git).

### 9.1 lazygit
- **Installation**: `lazygit` in nixpkgs
- **Features**: Interactive TUI for git operations, staging, branching, diffs
- **Learning Curve**: Low (intuitive keybinds)
- **Customization**: Good (config file)
- **Integration**: ✓ Available, active development
- **Use Case**: Visual git workflow without leaving terminal

### 9.2 git add -i / git difftool
- **Installation**: Built into git
- **Features**: Interactive staging and viewing diffs
- **Learning Curve**: Low-Medium
- **Customization**: Via git config
- **Integration**: ✓ Already available
- **Use Case**: Careful staging and review

### 9.3 tig
- **Installation**: `tig` in nixpkgs
- **Features**: Git log viewer and browser, interactive
- **Learning Curve**: Low
- **Customization**: Moderate
- **Integration**: ✓ Available
- **Use Case**: Git history exploration and visualization

---

## 10. Database Tools

### Category Overview
Database clients and management entirely in terminal.

### 10.1 mycli / pgcli
- **Installation**: Both in nixpkgs
- **Features**: MySQL/PostgreSQL clients with autocomplete, syntax highlight
- **Learning Curve**: Low (SQL knowledge required)
- **Customization**: Good (config files)
- **Integration**: ✓ Both available
- **Use Case**: Database development and administration

### 10.2 DBeaver CLI / usql
- **Installation**: `usql` in nixpkgs (universal SQL client)
- **Features**: Multi-database support, history, autocomplete
- **Learning Curve**: Low-Medium
- **Customization**: Moderate
- **Integration**: ✓ Available
- **Use Case**: Multi-database administration

---

## 11. System Configuration & Administration

### Category Overview
Configure and manage systems from pure terminal.

### 11.1 nmtui (NetworkManager TUI)
- **Installation**: Included with NetworkManager
- **Features**: Network configuration, WiFi management
- **Learning Curve**: Low
- **Customization**: Limited (system-level)
- **Integration**: ✓ Available with NetworkManager
- **Use Case**: Network troubleshooting and WiFi setup

### 11.2 bluetoothctl
- **Installation**: Built into bluez package
- **Features**: Bluetooth device pairing and management
- **Learning Curve**: Low
- **Customization**: Limited
- **Integration**: ✓ Available
- **Use Case**: Bluetooth pairing without GUI

### 11.3 passwd / usermod / visudo
- **Installation**: Standard Unix tools
- **Features**: User account and permission management
- **Learning Curve**: Medium
- **Customization**: Limited (system-level)
- **Integration**: ✓ Available
- **Use Case**: User administration

---

## 12. Productivity & Task Management

### Category Overview
Organize tasks and personal information entirely in terminal.

### 12.1 todo / taskwarrior
- **Installation**: `taskwarrior` in nixpkgs
- **Features**: Task management with projects, tags, time tracking, reporting
- **Learning Curve**: Low-Medium
- **Customization**: Very good (config, themes)
- **Integration**: ✓ Available, active community
- **Use Case**: Task organization, time tracking, project management

### 12.2 Org-mode (Emacs)
- **Installation**: As part of emacs-nox
- **Features**: Notes, lists, tables, agenda, literate programming
- **Learning Curve**: Medium-High
- **Customization**: Extensive
- **Integration**: ✓ With Emacs
- **Use Case**: Complete knowledge management system

### 12.3 notes / jrnl
- **Installation**: `jrnl` in nixpkgs
- **Features**: Journal/note taking with timestamp, search, tags
- **Learning Curve**: Low
- **Customization**: Moderate
- **Integration**: ✓ Available
- **Use Case**: Quick note taking and journaling

---

## Integration Recommendations for NixOS Configuration

### High Priority (Already Integrated)
- ✓ fzf (fuzzy finder)
- ✓ bat (cat replacement with syntax highlighting)
- ✓ ripgrep (faster grep)
- ✓ jq/yq (JSON/YAML processing)
- ✓ git (with enhanced configuration)
- ✓ neovim (primary editor)
- ✓ tmux (terminal multiplexer)

### Medium Priority (Recommended for Addition)
- lazygit (improved git workflow) - `lazygit` package
- bottom (system monitoring) - Already added to development tools
- broot (directory exploration) - `broot` package
- tealdeer (tldr client) - Already added to development tools

### Optional (Power User Tools)
- helix (modern editor alternative)
- neomutt (email client)
- weechat (IRC/messaging)
- taskwarrior (task management)
- emacs-nox (complete environment)

### Implementation Notes
1. Most tools can be added to `lib/users/brojo/programs/` with individual module files
2. Consider `programs.fzf.enable = true` for integration
3. Shell aliases in zsh config enhance discoverability
4. Many tools support color schemes matching Gruvbox theme

---

## Conclusion

The terminal ecosystem provides mature, well-maintained alternatives to most traditional GUI applications. Key advantages:
- **Scriptability**: Automation and integration into workflows
- **Lightweight**: Minimal resource usage
- **SSH-friendly**: Works over remote connections
- **Customizable**: Extensive configuration options
- **Unix Philosophy**: Composable tools that work together

Recommended approach: Start with tools already in configuration (editors, git, tmux), add lazygit and broot for common workflows, then explore category-specific tools as needs arise.

---

## Research Date
November 15, 2025

## Status
Complete - Ready for implementation consideration
