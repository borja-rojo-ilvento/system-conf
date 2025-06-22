{
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
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
      rust-analyzer
      ruff
      nil
      fzf
      claude-code
    ];
    # plugins = with pkgs.vimPlugins; [
    #   lazy-nvim
    # ];
    # extraConfig = ''
    #   require("config.lazy")
    #   '';
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
