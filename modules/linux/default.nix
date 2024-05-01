{ user, pkgs, ... }:
{
  imports = [ ../base ];

  system.stateVersion = "24.05";

  users.users."${user.username}".isNormalUser = true;
  environment.systemPackages = with pkgs; [ wl-clipboard ];
}
