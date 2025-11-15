{ pkgs, ... }:
{
  # Terminal multiplexer - tmux for session management
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    historyLimit = 50000;
    escapeTime = 0;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
    ];
    extraConfig = ''
      # Set default terminal
      set -g default-terminal "screen-256color"
      set-option -sa terminal-overrides ",xterm*:RGB"

      # Binding for splitting windows
      bind-key v split-window -h -c "#{pane_current_path}"
      bind-key s split-window -v -c "#{pane_current_path}"

      # Move between panes with vim keys
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # Resize panes
      bind-key H resize-pane -L 5
      bind-key J resize-pane -D 5
      bind-key K resize-pane -U 5
      bind-key L resize-pane -R 5

      # Reload config
      bind-key r source-file ~/.config/tmux/tmux.conf

      # Mouse support
      set -g mouse on

      # Status bar styling - minimal
      set -g status-bg "colour235"
      set -g status-fg "colour245"
      set -g window-status-format "#[fg=colour245]#I:#W"
      set -g window-status-current-format "#[bg=colour166,fg=colour235,bold] #I:#W "
      set -g status-left "[#S] "
      set -g status-right "%H:%M"
    '';
  };

  # Neovim configuration is already imported via neovim.nix
  # This ensures editor integration is available

  # Build tools and debuggers
  home.packages = with pkgs; [
    # Debuggers
    gdb
    lldb

    # Build system tools
    cmake
    meson
    ninja
    pkg-config

    # Documentation tools
    man-pages
    man-pages-posix
    tealdeer # Provides tldr command

    # Version control tools (beyond git)
    git-lfs
    git-crypt

    # Development utilities
    universal-ctags
    cscope
    bear # For generating compile_commands.json

    # REPL and testing
    bats # Bash Automated Testing System

    # Language-specific tools already installed: rustc, cargo, go, nodejs, clang, jdk
    # Linters and formatters
    shellcheck
    shfmt
    markdownlint-cli
    yamllint

    # Terminal utilities for development
    curl
    wget
    httpie
    jq
    yq
    sqlite

    # File managers and tools
    fd
    sd
    bottom # System monitor (like top)

  ];

  # Git configuration is in programs/default.nix
  # Enhanced here with signing and credential helpers
  programs.git.extraConfig = {
    # Improved diff and merge behavior
    diff.algorithm = "histogram";
    merge.conflictStyle = "zdiff3";

    # Useful helpers
    init.defaultBranch = "master";
    pull.rebase = true;
    fetch.prune = true;

    # Output formatting
    log.decorate = "auto";
    status.aheadBehind = true;
  };

  # Shell integration for development
  programs.zsh.initContent = ''
    # Development-related aliases
    alias ll='eza -lah'
    alias la='eza -la'
    alias l='eza -l'
    alias grep='grep --color=auto'

    # Git aliases
    alias gs='git status'
    alias ga='git add'
    alias gc='git commit'
    alias gp='git push'
    alias gpl='git pull'
    alias gb='git branch'
    alias gco='git checkout'
    alias gd='git diff'
    alias gl='git log --oneline'

    # Development tool shortcuts
    alias dx='direnv allow'
    alias mn='man'
    alias t='tmux'

    # Nix development
    alias nd='nix develop'
    alias ns='nix shell'
    alias nr='nix run'
    alias nf='nix flake'
  '';

  # Editor-agnostic development configuration
  xdg.configFile = {
    # EditorConfig for consistent coding styles
    ".editorconfig".text = ''
      # EditorConfig for consistent code style across tools
      root = true

      [*]
      indent_style = space
      indent_size = 2
      end_of_line = lf
      charset = utf-8
      trim_trailing_whitespace = true
      insert_final_newline = true

      [*.py]
      indent_size = 4

      [*.go]
      indent_style = tab

      [*.md]
      trim_trailing_whitespace = false
    '';

    # Git hooks directory
    "git-hooks/.gitkeep".text = "";
  };
}
