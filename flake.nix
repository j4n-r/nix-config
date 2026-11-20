{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
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
      url = "github:duxlabs-dev/dux-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dank-greeter = {
      url = "github:AvengeMedia/dank-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
    hex = {
      url = "github:anomalyco/hex/v3.4.0";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
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
    # Private modules (work hosts and endpoints); fetching it needs SSH access to GitHub.
    nix-private.url = "git+ssh://git@github.com/j4n-r/nix-private";
    # Tracks imputnet/helium-linux releases via CI; `nix flake update` bumps Helium
    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      emacs-overlay,
      zig-overlay,
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
            # Grafana MCP for Amp, with its token from sops (private nix-private repo).
            inputs.nix-private.nixosModules.arrivo-grafana-mcp
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
            # Grafana MCP for Amp, with its token from sops (private nix-private repo).
            inputs.nix-private.nixosModules.arrivo-grafana-mcp
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
                roc-overlay.overlays.default
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

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
