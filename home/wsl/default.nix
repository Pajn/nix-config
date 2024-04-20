{ user, ... }: {
  imports = [ ../base ];

  home.homeDirectory = "/home/${user.username}";
}
