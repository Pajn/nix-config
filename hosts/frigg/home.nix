{ ... }:
{
  imports = [ ../../home/linux ../../home/linux/gui.nix ];
  programs.git.extraConfig.user.signingKey = "~/.ssh/id_ed25519.pub";
  programs.zsh = {
    shellAliases = {
      switch = "sudo nixos-rebuild switch --flake ~/Development/nix-config#frigg";
    };
  };
}
