{
  pkgs,
  user,
  mypkgs,
  config,
  ...
}:
{
  imports = [
    ../base
    ./zsh.nix
    # ./docker.nix 
  ];

  home = {
    username = user.username;
    homeDirectory = "/Users/${user.username}";
    stateVersion = "23.11";
    # sessionVariables = {
    #   EDITOR = "nvim";
    #   # SHELL = "$HOME/.nix-profile/bin/zsh";
    # };

    file = {
      ".config/karabiner/assets/complex_modifications/remapping.json".source = ./config/karabiner/assets/complex_modifications/remapping.json;
      ".config/skhd/skhdrc".source = ./config/skhd/skhdrc;
      ".config/yabai/yabairc".source = ./config/yabai/yabairc;
    };
  };

  # home.packages = with pkgs; [
  #   # mypkgs.app-launcher
  #   # mypkgs.darwin.altair
  #   # mypkgs.darwin.obsidian
  #   # mypkgs.darwin.vlc
  #   # mypkgs.darwin.wombat
  #   # reattach-to-user-namespace
  #   # rectangle
  # ];
}
