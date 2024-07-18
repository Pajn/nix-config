
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pwvucontrol
    spotify
    vlc
  ];
}
