{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zig-overlay.url = "github:mitchellh/zig-overlay";
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dank-greeter = {
      url = "github:AvengeMedia/dank-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
    openwhispr = {
      url = "github:OpenWhispr/openwhispr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    roc-overlay = {
      url = "github:roc-lang/roc-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      emacs-overlay,
      zig-overlay,
      niri,
      sops-nix,
      deploy-rs,
      roc-overlay,
      ...
    }:
    {
      nixosConfigurations = {
        j4n-r-hmb = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/j4n-r-hmb
            ./modules/base.nix
            ./modules/dev.nix
            ./modules/nixos/desktop.nix
            ./modules/nixos/git-signing.nix
            ./modules/nixos/base.nix
            ./modules/nixos/unstable.nix
            ./modules/nixos/insecure.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                };
                users.j4n-r = import ./hosts/j4n-r-hmb/home.nix;
                sharedModules = [
                  inputs.dms.homeModules.dank-material-shell
                  inputs.dms-plugin-registry.nixosModules.default
                  inputs.dms.homeModules.niri
                  inputs.niri.homeModules.niri
                ];
              };
            }
            {
              nixpkgs.overlays = [
                emacs-overlay.overlays.default
                zig-overlay.overlays.default
                niri.overlays.niri
                roc-overlay.overlays.default
              ];
            }
          ];
        };
        j4n-r-tp6 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/j4n-r-tp6
            ./modules/base.nix
            ./modules/dev.nix
            ./modules/nixos/desktop.nix
            ./modules/nixos/git-signing.nix
            ./modules/nixos/base.nix
            ./modules/nixos/unstable.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                };
                users.j4n-r = import ./hosts/j4n-r-tp6/home.nix;
                sharedModules = [
                  inputs.dms.homeModules.dank-material-shell
                  inputs.dms-plugin-registry.nixosModules.default
                  inputs.dms.homeModules.niri
                  inputs.niri.homeModules.niri

                ];
              };
            }
            ({
              nixpkgs.overlays = [
                emacs-overlay.overlays.default
                zig-overlay.overlays.default
                niri.overlays.niri

              ];
            })
          ];
        };
        netcache = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            inputs.disko.nixosModules.disko
            sops-nix.nixosModules.sops
            ./hosts/netcache
          ];
        };
      };
      deploy.nodes.netcache = {
        hostname = "netcache";
        sshUser = "root";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.netcache;
        };
      };

      darwinConfigurations."MacBook-Air-100011" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          username = "jr";
          hostname = "MacBook-Air-100011";
        };
        modules = [
          ./hosts/MacBook-Air-100011/user-hosts.nix
          ./modules/base.nix
          ./modules/dev.nix
          ./modules/darwin/system.nix
          ./modules/darwin/homebrew.nix
          ./modules/darwin/base.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jr = import ./hosts/MacBook-Air-100011/home.nix;

          }
          ({
            nixpkgs.overlays = [ emacs-overlay.overlays.default ];
          })
        ];
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
