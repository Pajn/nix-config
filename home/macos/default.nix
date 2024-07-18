{ pkgs, user, ... }:
{
  imports = [
    ../base
    ../base/cloud.nix
    ./zsh.nix
    # ./docker.nix 
  ];

  home = {
    username = user.username;
    homeDirectory = "/Users/${user.username}";
    stateVersion = "23.11";

    file = {
      ".config/karabiner/assets/complex_modifications/remapping.json".source = ./config/karabiner/assets/complex_modifications/remapping.json;
      ".config/skhd/skhdrc".source = ./config/skhd/skhdrc;
      ".config/yabai/yabairc".source = ./config/yabai/yabairc;
    };
  };

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    fira-code
    geist-font
    inconsolata
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];
}
