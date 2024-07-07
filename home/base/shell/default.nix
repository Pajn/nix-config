{ pkgs, ... }:
{

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
      ls = "eza";
      df = "df -h"; # Human-readable sizes
      free = "free -m"; # Show sizes in MB
      grep = "grep --color=auto";
      diff = "diff --color=auto";
      n = "nvim";
      kc = "kubectl";
      do = "just --working-directory \"$(just --evaluate pwd)/$(echo \"\${PWD#`just --evaluate pwd`}\" | cut -d '/' -f2)\" --justfile \"$(just --evaluate pwd)/dofile\"";
    };
    initExtra = builtins.concatStringsSep "\n" [
      # ''. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"''
      (builtins.readFile ./zshrc.sh)
      (builtins.readFile ./wezterm.sh)
    ];
  };
  home.packages = with pkgs; [
    (writeShellScriptBin "do" ''
      just --working-directory "''$(just --evaluate pwd)/''$(echo "''${PWD#`just --evaluate pwd`}" | cut -d '/' -f2)" --justfile "''$(just --evaluate pwd)/dofile" ''$@
    '')
    ueberzugpp
  ];

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

      dotnet.disabled = true;

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
      enter_accept = true;
      filter_mode_shell_up_key_binding = "directory";
      keymap_mode = "vim-insert";
      keymap_cursor = {
        emacs = "steady-block";
        vim_insert = "steady-bar";
        vim_normal = "steady-block";
      };
    };
  };

  programs.zoxide.enable = true;
  programs.direnv.enable = true;

  programs.eza.enable = true;
}
