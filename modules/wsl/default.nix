{ user, pkgs, ... }:
{
  imports = [ ../linux ];

  system.stateVersion = "24.05";

  wsl.enable = true;
  wsl.defaultUser = user.username;
  #wsl.docker-desktop.enable = true;
}
