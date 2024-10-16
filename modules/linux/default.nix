{
  user,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ../base ];

  users.users."${user.username}".isNormalUser = true;

  # minimum amount of swapping without disabling it entirely
  boot.kernel.sysctl."vm.swappiness" = lib.mkDefault 1;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=15s
  '';

  environment.systemPackages = with pkgs; [
    wl-clipboard
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    # docker-compose # start group of containers for dev
    podman-compose # start group of containers for dev
  ];

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  fonts.packages = with pkgs; [
    fira-code
    geist-font
    inconsolata
    inter
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];

  # Configure keymap
  services.xserver.xkb = {
    layout = "us-swe";
    variant = "";

    extraLayouts.us-swe = {
      description = "US layout with alt-gr swedish";
      # languages = [ "eng" "swe" ];
      languages = [ "eng" ];
      symbolsFile = ./us-swe;
    };
  };
  environment.variables."XKB_DEFAULT_LAYOUT" = "us-swe";

  services.flatpak.enable = true;
}
