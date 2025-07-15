{
  pkgs,
  config,
  ...
}:

{

  imports = [
    ./fonts.nix
    ./fish.nix
    ./starship.nix
    ./zathura.nix
    ./ghostty.nix
    ./btop.nix
    ./direnv.nix
    ./cmd.nix
    ./spell-check.nix
    ./zellij.nix
  ];

}
