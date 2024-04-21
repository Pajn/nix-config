{
  lib,
  pkgs,
  config,
  user,
  ...
}:
{

  # age.secrets.github-token.file = ../../../secrets/github-token.age;

  programs.zsh = {
    defaultKeymap = "viins";
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    autocd = false;
    history = {
      save = 50000;
      size = 50000;
      share = true;
    };

    shellAliases = {
      ".." = "cd ..";
      cp = "cp -i"; # Confirm before overwriting something
      df = "df -h"; # Human-readable sizes
      free = "free -m"; # Show sizes in MB
      grep = "grep --color=auto";
      diff = "diff --color=auto";
      n = "nn";
      kc = "kubectl";
    };
    initExtra = builtins.concatStringsSep "\n" [
      # ''. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"''
      (builtins.readFile ./zshrc.sh)
      (builtins.readFile ./wezterm.sh)
    ];
    #
    # profileExtra = ''
    #   idconvert() {
    #     syb -env production idconvert $1
    #   }
    # '';

    plugins = [
      # {
      #   name = "zsh-autosuggestions";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "zsh-users";
      #     repo = "zsh-autosuggestions";
      #     rev = "v0.6.4";
      #     sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
      #   };
      # }
      # {
      #   name = "zsh-vim-mode";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "softmoth";
      #     repo = "zsh-vim-mode";
      #     rev = "main";
      #     sha256 = "a+6EWMRY1c1HQpNtJf5InCzU7/RphZjimLdXIXbO6cQ=";
      #   };
      # }
    ];
  };

  programs.starship = {
    enable = true;
    settings = {

      format = "$directory$all$localip$kubernetes$cmd_duration$line_break$character";

      character = {
        success_symbol = "[❯](bold purple)";
      };

      directory = {
        truncation_length = 5;
        truncation_symbol = "…/";
        truncate_to_repo = false;
      };

      hostname = {
        style = "bold yellow";
      };

      memory_usage = {
        disabled = false;
      };

      aws = {
        disabled = true;
      };

      docker_context = {
        disabled = true;
      };

      gcloud = {
        disabled = true;
      };

      nodejs = {
        disabled = true;
      };

      swift = {
        disabled = true;
      };

      ruby = {
        disabled = true;
      };

      kubernetes = {
        disabled = false;
        format = "[$symbol$context(::$namespace)]($style) ";
      };

      localip = {
        disabled = true;
        ssh_only = false;
      };
    };
  };

  programs.atuin = {
    enable = true;
    settings = {
      dialect = "uk";
      filter_mode_shell_up_key_binding = "directory";
    };
  };

  programs.zoxide.enable = true;
  programs.direnv.enable = true;

  programs.eza.enable = true;
}
