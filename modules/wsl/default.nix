{ user, ... }: {
imports = [ ../base ];

wsl.enable = true;
wsl.defaultUser = user.username;
#wsl.docker-desktop.enable = true;
}
