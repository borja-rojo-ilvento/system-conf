{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    neovim
    python3
    git
    gnumake
    rustup
    unzip
    lua51Packages.lua
    luarocks
    ripgrep
    fd
    clang
    tree-sitter
    lua-language-server
    # rust-analyzer is provided by rustup as a proxy binary (run
    # `rustup component add rust-analyzer` once per host). Listing the
    # standalone package alongside rustup makes Home Manager's buildEnv
    # fail with a `bin/rust-analyzer` path collision.
    ruff
    nil
    fzf
    claude-code
    vale
  ];

  home.sessionVariables.EDITOR = "nvim";
  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  # ── Anex: prior approaches and why they were dropped ────────────────────────
  #
  # Tried: programs.neovim.enable = true with extraPackages, defaultEditor,
  # viAlias/vimAlias, and (briefly) extraConfig/plugins for a Nix-managed
  # init.lua. Dropped because the real nvim config lives as a hand-managed
  # lazy.nvim git checkout in ~/.config/nvim, and Home Manager's
  # programs.neovim insists on writing its own init.lua, which collided with
  # the existing one and caused home-manager-brojo.service to fail on every
  # rebuild ("Existing file '/home/brojo/.config/nvim/init.lua' would be
  # clobbered"). Going forward, treat ~/.config/nvim as out-of-Nix; Home
  # Manager only installs the binary and tooling.
}
