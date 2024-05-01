{ user, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
}
