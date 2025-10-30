{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";

    niri.url = "github:sodiboo/niri-flake";
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };
  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      hyprland,
      nix-darwin,
      emacs-overlay,
      zig-overlay,
      niri,
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
            ./modules/nixos/base.nix
            ./modules/nixos/unstable.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                  hyprlandMonitorConfig = ''
                    monitor=DP-1,highres@highrr,0x0,1.5
                    monitor=eDP-1,highres@highrr,3200x0,1

                    workspace=1,monitor:DP-1, default:true
                    workspace=2,monitor:DP-1
                    workspace=3,monitor:DP-1
                    workspace=4,monitor:DP-1
                    workspace=5,monitor:DP-1
                    workspace=6,monitor:DP-1
                    xwayland {
                        force_zero_scaling = true
                    }
                  '';
                };
                users.j4n-r = import ./hosts/j4n-r-hmb/home.nix;
              };
            }
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [
                  emacs-overlay.overlays.default
                  zig-overlay.overlays.default
                ];
              }
            )
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
            ./modules/nixos/base.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                  hyprlandMonitorConfig = ''
                    monitor=DP-1,highres@highrr,0x0,1.5
                    monitor=eDP-1,highres@highrr,3200x0,1

                    workspace=1,monitor:DP-1, default:true
                    workspace=2,monitor:DP-1
                    workspace=3,monitor:DP-1
                    workspace=4,monitor:DP-1
                    workspace=5,monitor:DP-1
                    workspace=6,monitor:DP-1
                    xwayland {
                        force_zero_scaling = true
                    }
                  '';
                };
                users.j4n-r = import ./hosts/j4n-r-tp6/home.nix;
              };
            }
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [
                  emacs-overlay.overlays.default
                  zig-overlay.overlays.default
                ];
              }
            )
          ];
        };
        j4n-r-rpi5 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/j4n-r-pi5
            ./modules/base.nix
            ./modules/nixos/base.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                  hyprlandMonitorConfig = ''
                    monitor=eDP-1,1920x1080,3440x0,1 
                    monitor=DP-1,2560x1440@60,0x0,1.3 # 60hz is max for the usbc output
                    monitor=DP-2,1920x1200,0x0,1
                    monitor = , preferred, 0x0, 1

                    workspace=1,monitor:DP-1 , default:true
                    workspace=2,monitor:DP-1
                    workspace=3,monitor:DP-1
                    workspace=4,monitor:DP-1
                    workspace=5,monitor:DP-1
                    workspace=6,monitor:DP-1
                  '';
                };
                users.j4n-r = import ./hosts/j4n-r-hmb/home.nix;
              };
            }
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [ emacs-overlay.overlays.default ];
              }
            )
          ];
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

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = [ emacs-overlay.overlays.default ];
            }
          )
        ];
      };
    };
}
