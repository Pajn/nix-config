{ pkgs, lib, ... }:
{

  home.packages = with pkgs; [
    delta
    diff-so-fancy
    git-absorb
    # git-open
    # git-ps-rs
    # gitmux
    # spr
  ];

  home.file.".ssh/allowed_signers".text = ''
    * ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnCd3pS1o2QF9FblX294ZTFXGf/bISTU+VXKU15hD5CPZNJLWpmpM40oGCWC/m4xmMhML6hRDV5Yko0hWknZOD1oSRWE+Yhob7M88IwJLz3GPBC47JFNh+t20Yq8cFwgQ/Ww6v3I3EZYmJ7AXse3+eHl6lFuqVb10TMZnWghzcYEkR43vds8u/Udnc6sqLuRCc7mqRCNi5kN9ead2StSdNRqGhH95s44LvpjS9oQoLY0wGGwAz4Db0S0NHa1B56EgmJwGuKoSvsU0KLbuwddbWH5/xd7gZiCwJXpwwJkOg++HVvNrzDBC9AY5bTQT7t38vt7YnjjIfdFpPnAES/vsN/arYWOhHgzspoD4PlWiCTm8LkxYCnrMklWdNTj8nsGL0ZrnbWtrtl+l0z8FlfFi6Kj1+r7/XbpWRgLD0JuVHLB4rTEJg848qhXl0OJLjeqvVl+NlJKxupjE0Z/2xs9h6SL7H26XTYOmekGRu4JQYXIcdRvmCrhCt/i4PWUhmrK0=
    * ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKtL49R/kwKZQeTxO3h2EILcmtWNX6S7KPvceoiZ5nUPjIqevZNhWA6ygPC/P02sagmsMW6fcvpT7wfb6EJApZwey07hCJ7Q2bBaoMqWKgU3Yg3VGFF09Rhn8UyrjuFcfezsp7P2ufj2jsfsmBJxB8VYINirCn+vis3e/jLCk0vJpESzHPmoUz7ZAolqdQwoBW35b8NwsHq6Av/GXwdnjlZsj9mrIcTUjHM2dO1+KY1tIo2YgSNVOCS5jQPBLt+4YJ94qq1uH7z3IVhw47fag9199s7zpPwI9cm/Mlb1jzu/sQbsYxx4YRGKA1IrNGZUgYQBIknRj96ZGMJ+CAguDpvcEH9JkPlioxq3fhkq5plHJR8kL1hJLhPuYmgjyZBmBxSyQuM/596S9ey95kOVQHx23IUdjdYyWgpA4fJI9JYBLrWSr2GcNMJh90z+4sLxW8aQO463PvF2lhriGRrQV2qlS3+SETuKJtIiOZkwBs12vUStOAx0VqyBsFD3w3VF0=
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFOSq9QDUV7H1uNOV78w2ICH4oOUbZQozL4SNbn2jL7t rasmus@nixos
  '';

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Rasmus Eneman";
    userEmail = "rasmus@eneman.eu";
    ignores = [
      ".cache/"
      ".DS_Store"
      ".idea/"
      "*.swp"
      "dumb.rdb"
      ".elixir_ls/"
      "npm-debug.log"
    ];
    aliases = {
      c = "commit";
      cm = "commit -m";
      s = "status";
      l = "log --graph --decorate --pretty='%C(yellow)%h%Creset%Cred%d%Creset - %an %C(cyan)%ar%Creset %s %Cgreen'";

      tree = "log --graph --decorate --all --pretty='%C(yellow)%h%Creset%Cred%d%Creset - %an %C(cyan)%ar%Creset %s %Cgreen'";

      # Change to default branch (main/master/???)
      main = "!git switch $(basename $(git symbolic-ref --short refs/remotes/origin/HEAD))";

      # From https://adamj.eu/tech/2022/10/30/git-how-to-clean-up-squash-merged-branches/
      rm-gone-from-remote = ''!git branch --format '%(refname:short) %(upstream:track)' | awk '$2 == "[gone]" { print $1 }' | xargs -r git branch -D'';

      # Update from remote and delete all branches removed from remote
      resync = "!git main && git pull --prune && git rm-gone-from-remote";
    };

    extraConfig = {
      core = {
        editor = "nvim";
        whitespace = "trailing-space,space-before-tab";
      };

      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };

      rerere = {
        enabled = "true";
        autoUpdate = "true";
      };
      rebase.updateRefs = "true";
      commit.gpgsign = "true";
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingKey = lib.mkDefault "~/.ssh/id_rsa.pub";

      pull.rebase = "true";
      init.defaultBranch = "main";
      # push.autoSetupRemote = "true";

      "includeIf \"gitdir:~/Development/\"" = {
        path = "~/Development/.gitconfig";
      };

      "includeIf \"gitdir:~/Projects/\"" = {
        path = "~/Projects/.gitconfig";
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      promptToReturnFromSubprocess = false;
      git.mainBranches = [
        "master"
        "main"
        "develop"
      ];
      os = {
        openCommand = "nvim";
        openCommandTemplate = "{{editor}} --server /tmp/nvim-server.pipe --remote-tab \"$(pwd)/{{filename}}\"";
      };
    };
  };

  programs.gh = {
    enable = true;
  };

  programs.gh-dash = {
    enable = true;
  };
}
