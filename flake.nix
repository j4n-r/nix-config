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
    # Pull-based deploys: hetzner polls the `deploy` branch and switches itself.
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    roc-overlay = {
      url = "github:roc-lang/roc-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Private modules (work hosts and endpoints); fetching it needs SSH access to GitHub.
    nix-private.url = "git+ssh://git@github.com/j4n-r/nix-private";
    # Keep Tulsi's own nixpkgs pin: it needs a newer Go than NixOS 26.05 provides.
    tulsi.url = "git+ssh://git@github.com/j4n-r/tulsi.git";
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
        hetzner = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            inputs.disko.nixosModules.disko
            sops-nix.nixosModules.sops
            ./hosts/hetzner
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
      # aarch64 server: the x86 laptop cannot build it, so the server builds its own closure.
      deploy.nodes.hetzner = {
        hostname = "91.99.52.144";
        sshUser = "root";
        remoteBuild = true;
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.hetzner;
        };
      };

      # Each system checks only the nodes it can build.
      checks = builtins.mapAttrs (
        system: deployLib:
        deployLib.deployChecks (
          self.deploy
          // {
            nodes = nixpkgs.lib.filterAttrs (
              _: node: node.profiles.system.path.system == system
            ) self.deploy.nodes;
          }
        )
      ) deploy-rs.lib;
    };
}
