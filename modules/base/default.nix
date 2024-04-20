{ pkgs, lib, user, ... }: {
programs.zsh.enable = true;
              users.users."${user.username}".shell = pkgs.zsh;

environment.pathsToLink = [ "/share/zsh" ];
environment.systemPackages = with pkgs; [
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
    ripgrep
    jq
    yq

    wget
    curl

    which
    tree

    gcc
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
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
