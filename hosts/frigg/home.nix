{ ... }:
{
  imports = [ ../../home/linux ];
  programs.git.extraConfig.user.signingKey = "~/.ssh/id_ed25519.pub";
}
