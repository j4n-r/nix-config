{ pkgs, config, ... }:

{

  imports = [
    ./fonts.nix
  ];

  home.packages = with pkgs; [
  ];
}
