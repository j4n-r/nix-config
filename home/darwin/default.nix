{ pkgs, config, ... }:

{

  imports = [
    ./amethyst.nix
    ./karabiner.nix
    ./packages.nix
  ];

}
