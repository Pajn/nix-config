{ pkgs, ... }:
{
  imports = [ ../base/gui.nix ];

  home.packages = with pkgs; [
    bazecor
    pwvucontrol
    spotify
    vlc
  ];
}
