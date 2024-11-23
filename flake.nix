{
  description = "Rasmus nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Linux Systems
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Darwin Systems
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "nix-darwin";
    };
    # homebrew-bundle = {
    #   url = "github:homebrew/homebrew-bundle";
    #   flake = false;
    # };
    # homebrew-core = {
    #   url = "github:homebrew/homebrew-core";
    #   flake = false;
    # };
    # homebrew-cask = {
    #   url = "github:homebrew/homebrew-cask";
    #   flake = false;
    # };

    # WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Other
    # wezterm = {
    #   # url = "github:wez/wezterm?dir=nix";
    #   # url = "github:Pajn/wezterm/float-pane?dir=nix";
    #   url = "github:e82eric/wezterm/move-float-to-split?dir=nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    {
      self,
      nixpkgs,
      lix-module,
      home-manager,

      lanzaboote,
      nixos-cosmic,
      niri,

      nix-darwin,
      nix-homebrew,
      # homebrew-bundle,
      # homebrew-core,
      # homebrew-cask,

      nixos-wsl,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      user = {
        name = "Rasmus Eneman";
        username = "rasmus";
      };
      genSpecialArgs =
        system:
        inputs
        // rec {
          inherit user inputs;

          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.allowBroken = true;

            overlays = [ niri.overlays.niri ];
          };

          _custom = import ./packages { inherit pkgs lib; };
        };
    in
    {
      darwinConfigurations = {
        "Rasmuss-MacBook-Pro-2" =
          let
            specialArgs = genSpecialArgs "aarch64-darwin";
          in
          nix-darwin.lib.darwinSystem {
            inherit inputs;

            system = "aarch64-darwin";
            specialArgs = specialArgs;
            modules = [
              # ./hosts/m1
              ./modules/macos
              # ./modules/macos/brew.nix

              lix-module.nixosModules.default
              home-manager.darwinModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = specialArgs;
                  users."${user.username}" = import ./home/macos;
                };
              }
              # nix-homebrew.darwinModules.nix-homebrew
              # {
              #   nix-homebrew = {
              #     user = user.username;
              #     enable = true;
              #     enableRosetta = true;
              #     taps = {
              #       "homebrew/homebrew-core" = homebrew-core;
              #       "homebrew/homebrew-cask" = homebrew-cask;
              #       "homebrew/homebrew-bundle" = homebrew-bundle;
              #     };
              #     mutableTaps = false;
              #     # autoMigrate = true;
              #   };
              # }
            ];
          };
      };

      homeConfigurations = {
        idun =
          let
            specialArgs = genSpecialArgs "x86_64-linux";
          in
          home-manager.lib.homeManagerConfiguration {
            inherit (specialArgs) pkgs;
            extraSpecialArgs = specialArgs;

            modules = [ ./home/linux ];
          };
      };

      nixosConfigurations = {
        frigg =
          let
            specialArgs = genSpecialArgs "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            inherit specialArgs;
            modules = [
              lix-module.nixosModules.default
              lanzaboote.nixosModules.lanzaboote
              {
                nix.settings = {
                  substituters = [ "https://cosmic.cachix.org/" ];
                  trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
                };
              }
              nixos-cosmic.nixosModules.default
              # niri.nixosModules.niri
              ./hosts/frigg
              ./modules/linux
              ./modules/linux/boot.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = specialArgs;
                  users."${user.username}" = import ./hosts/frigg/home.nix;
                };
              }
            ];
          };
        garm =
          let
            specialArgs = genSpecialArgs "aarch64-linux";
          in
          nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            inherit specialArgs;
            modules = [
              lix-module.nixosModules.default
              ./hosts/garm
              ./modules/linux
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = specialArgs;
                  users."${user.username}" = import ./hosts/garm/home.nix;
                };
              }
            ];
          };
        wsl =
          let
            specialArgs = genSpecialArgs "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            inherit specialArgs;
            modules = [
              lix-module.nixosModules.default
              nixos-wsl.nixosModules.default
              ./modules/wsl
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = specialArgs;
                  users."${user.username}" = import ./home/wsl;
                };
              }
            ];
          };
      };
    };
}
