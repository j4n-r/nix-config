{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      hyprland,
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
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.j4n-r = import ./hosts/j4n-r-hmb/home.nix;
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
            ./modules/nixos/base.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.j4n-r = import ./hosts/j4n-r-tp6/home.nix;
            }
          ];
        };
      };
    };
}
