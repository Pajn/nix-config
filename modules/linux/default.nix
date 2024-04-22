{ user, ... }:
{
  imports = [ ../base ];

  system.stateVersion = "24.05";

  home.homeDirectory = "/home/${user.username}";
  users.users."${user.username}".isNormalUser = true;
}
