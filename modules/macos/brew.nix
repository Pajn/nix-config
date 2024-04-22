{ ... }: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "zap";
    };

    masApps = {
    };

    casks = [
    ];

    brews = [
      # commands like `gsed` `gtar` are required by some tools
      "gnu-sed"
      "gnu-tar"
    ];
  };
}
