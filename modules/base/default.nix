{
  pkgs,
  lib,
  user,
  ...
}:
{
  nix.package = pkgs.lix;
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };
  nixpkgs.overlays = [
    (final: prev: import ../../packages { inherit lib pkgs; })
  ];

  programs.zsh.enable = true;
  users.users."${user.username}" = {
    description = user.name;
    shell = pkgs.zsh;
  };
  environment.pathsToLink = [ "/share/zsh" ];

  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=480
  '';

  environment.systemPackages = with pkgs; [
    theme-toggle-nvim

    git
    neovim

    # Archives
    zip
    xz
    zstd
    unzip
    p7zip
    gnutar

    # Text processing
    bat
    fd
    ripgrep
    jq
    yq

    wget
    curl

    eza
    which
    tree
    pstree
  ];

  nixpkgs.config = {
    ripgrep.withPCRE2 = true;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ user.username ];

    # Manual optimise storage: nix-store --optimise
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = lib.mkDefault true;
    options = lib.mkDefault "--delete-older-than 7d";
  };
}
