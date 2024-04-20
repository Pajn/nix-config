{ pkgs, config, user, ... }: {

  # age.secrets.github-token.file = ../../../secrets/github-token.age;

  programs.zsh = {
    defaultKeymap = "viins";
    enable = true;
    shellAliases = {
      ".." = "cd ..";
      grep = "grep --color=auto";
      kc = "kubectl";
      diff = "diff --color=auto";
    };
    autosuggestion.enable = true;
    enableCompletion = true;
    autocd = false;
    history = {
      save = 50000;
      size = 50000;
      share = true;
    };
    # initExtra = builtins.concatStringsSep "\n" [
    #   # ''. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"''
    #   (builtins.readFile ./scripts/init.sh)
    #   ''
    #     export JAVA_HOME="${config.home.sessionVariables.JAVA_HOME}"
    #     setopt PROMPT_SUBST
    #     export PROMPT='%F{white}%2~ %(?.%F{green}.%F{red})→%f '
    #     export RPROMPT=
    #     export GITHUB_TOKEN=$(${pkgs.coreutils}/bin/cat ${config.age.secrets.github-token.path})
    #   ''
    # ];
    #
    # profileExtra = ''
    #   idconvert() {
    #     syb -env production idconvert $1
    #   }
    # '';

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.6.4";
          sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
        };
      }
    ];
  };

  programs.starship = {
    enable = true;
    settings = {

format = "$directory$all$localip$kubernetes$cmd_duration$line_break$character";

character = {
success_symbol = "[❯](bold purple)";
}

directory = {
truncation_length = 5;
truncation_symbol = "…/";
truncate_to_repo = false;
}

hostname = {
style = "bold yellow";
}

memory_usage = {
disabled = false;
}

aws = {
disabled = true;
}

docker_context = {
disabled = true;
}

gcloud = {
disabled = true;
}

nodejs = {
disabled = true;
}

swift = {
disabled = true;
}

ruby = {
disabled = true;
}

kubernetes = {
disabled = false;
format = "[$symbol$context(::$namespace)]($style) ";
}

localip = {
disabled = true;
ssh_only = false;
}

}
