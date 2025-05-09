{
  description = "flakes to build/run stuff";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # build emacs vterm package
        devShells.emacs = pkgs.mkShell {
          packages = with pkgs; [
            cmake
            enchant
            pkg-config
            libvterm-neovim # test next time which one works
            libvterm
          ];
        };
        # for running eduroam script from https://cat.eduroam.org/
        devShells.eduroam = pkgs.mkShell {
          packages = with pkgs; [
            (pkgs.python313.withPackages (
              python-pkgs: with python-pkgs; [
                dbus-python
              ]
            ))
          ];
        };
      }
    );
}
