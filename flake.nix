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
  };

  outputs = { self, nixpkgs, nixos-wsl, nix-darwin, home-manager, nix-homebrew, homebrewbundle, homebrew-core, homebrew-cask, ... }:
    let
      lib = nixpkgs.lib;
      user = {
        name = "Rasmus Eneman";
        username = "rasmus";
      };
      darwinSystems = { aarch64-darwin = "aarch64-darwin"; };
      linuxSystems = { x86_64-linux = "x86_64-linux"; };
      allSystems = darwinSystems // linuxSystems;
      allSystemNames = builtins.attrNames allSystems;
      forAllSystems = f: (nixpkgs.lib.genAttrs allSystemNames f);
      genSpecialArgs = system:
        inputs // rec {
          inherit user agenix fonts;

          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          pkgs-stable = import inputs.nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        };
    in {
      # homeConfigurations = {
      #   rasmus = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     modules = [ ./home.nix ];
      #   };
      # };
      nixosConfigurations = {
        wsl = let specialArgs = genSpecialArgs "x86_64-linux";
        in nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          inherit specialArgs;
          modules = [
            nixos-wsl.nixosModules.default
            ./modules/wsl
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
