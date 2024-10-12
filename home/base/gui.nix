
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bazecor
    spotify
    vlc
  ];
}
