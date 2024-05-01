{
  description = "Rasmus nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "nix-darwin";
    };

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      lanzaboote,
      nixos-cosmic,
      nix-darwin,
      home-manager,
      nix-homebrew,
      homebrew-bundle,
      homebrew-core,
      homebrew-cask,
      agenix,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      user = {
        name = "Rasmus Eneman";
        username = "rasmus";
      };
      darwinSystems = {
        aarch64-darwin = "aarch64-darwin";
      };
      linuxSystems = {
        x86_64-linux = "x86_64-linux";
      };
      allSystems = darwinSystems // linuxSystems;
      allSystemNames = builtins.attrNames allSystems;
      forAllSystems = f: (nixpkgs.lib.genAttrs allSystemNames f);
      genSpecialArgs =
        system:
        inputs
        // rec {
          inherit user agenix;

          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          pkgs-stable = import inputs.nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
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

              agenix.darwinModules.default
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = specialArgs;
                home-manager.users."${user.username}" = import ./home/macos;
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
              lanzaboote.nixosModules.lanzaboote
              {
                nix.settings = {
                  substituters = [ "https://cosmic.cachix.org/" ];
                  trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
                };
              }
              nixos-cosmic.nixosModules.default
              ./hosts/frigg
              ./modules/linux
              ./modules/linux/boot.nix
              agenix.nixosModules.default
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = specialArgs;
                home-manager.users."${user.username}" = import ./hosts/frigg/home.nix;
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
              nixos-wsl.nixosModules.default
              ./modules/wsl
              agenix.nixosModules.default
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = specialArgs;
                home-manager.users."${user.username}" = import ./home/wsl;
              }
            ];
          };
      };
    };
}
