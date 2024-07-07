{
  config,
  lib,
  pkgs,
  ...
}:
let
in
# rustToolchain = pkgs.fenix.complete.withComponents [
#   "cargo"
#   "clippy"
#   "rust-src"
#   "rustc"
#   "rustfmt"
#   "rust-analyzer"
# ];
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages =
      with pkgs;
      [
        # Formatters
        alejandra # Nix
        nixfmt-rfc-style # Nix
        black # Python
        prettierd # Multi-language
        shfmt # Shell
        isort # Python
        stylua # Lua

        # LSP
        lua-language-server
        nixd
        nil
        rustup

        # Tools
        neovim-remote
        cmake
        fswatch # File watcher utility, replacing libuv.fs_event for neovim 10.0
        fzf
        gcc
        git
        gnumake
        lua51Packages.lua
        lua51Packages.luarocks
        nodejs
        sqlite
        tree-sitter
        cargo-outdated

        imagemagick
      ]
      ++ lib.lists.optional (!pkgs.stdenv.isDarwin) vscode-extensions.vadimcn.vscode-lldb.adapter;
    extraLuaPackages = ps: [ ps.magick ];
  };
}
