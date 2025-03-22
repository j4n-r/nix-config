{ pkgs, config, ... }:

{

  imports = [
    ./fonts.nix
    ./fish.nix
    ./starship.nix
    ./zathura.nix
    ./ghostty.nix
  ];

}
