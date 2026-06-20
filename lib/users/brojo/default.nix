{
  pkgs,
  ...
}:
{
  imports = [
    ./programs
  ];

  home.packages = with pkgs; [
    # stremio # Takes WAY too long to build.
    # git and ghostty are not listed here: programs.git and programs.ghostty
    # (in ./programs) install their own binaries into the profile. Dev CLI tools
    # (pkg-config, wget, jq, fd, sqlite, …) live in ./programs/development.nix.
    nix-search-cli
    firefox
    clang
    gnumake
    # Rust toolchain (cargo, rustc, rustfmt, clippy, rust-analyzer, …) is
    # managed via rustup, declared in lib/users/brojo/programs/neovim.nix.
    # Listing the standalone packages here collides with rustup's proxy
    # binaries in Home Manager's buildEnv.
    go
    nodejs
    code-cursor
    zoom-us
    xwayland
    zoxide
    ripgrep
    flameshot
    fzf
    ledger-live-desktop
    kdePackages.kscreen
    home-manager
    nmap
    arp-scan
    google-chrome
    obsidian
    jdk
    devbox
    stow
    openssl
    nix-direnv
    oh-my-zsh
    tree
    ani-cli
    claude-code
    godot
    bat
    pandoc
    texliveTeTeX
    texlivePackages.sectsty
    libnotify
    gh
    gemini-cli
    eza
    audacity
    freerdp
    remmina
    mesa-demos
    vscode
    # Audio control
    wireplumber
    playerctl
    # Terminal and fonts
    wl-clipboard
    nerd-fonts.jetbrains-mono
    opencode
    # Controller testing tools
    linuxConsoleTools  # Provides jstest for testing joystick input
    jstest-gtk         # GUI tool for testing game controllers
  ];

  services.ssh-agent.enable = true;

  home.stateVersion = "26.05";

}
