{ user, pkgs, ... }:
{
  imports = [ ../base ];

  home.homeDirectory = "/home/${user.username}";
}
