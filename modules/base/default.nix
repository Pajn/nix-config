{
  pkgs,
  lib,
  user,
  agenix,
  ...
}:
{
  programs.zsh.enable = true;
  users.users."${user.username}" = {
    description = user.name;
    shell = pkgs.zsh;
  };
  environment.pathsToLink = [ "/share/zsh" ];

  # minimum amount of swapping without disabling it entirely
  boot.kernel.sysctl."vm.swappiness" = lib.mkDefault 1;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';
  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=60
  '';

  environment.systemPackages = with pkgs; [
    agenix.packages."${pkgs.system}".default

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
  ];
  fonts.packages = with pkgs; [
    fira-code
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];

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
