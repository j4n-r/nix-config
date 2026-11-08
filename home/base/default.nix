{
  pkgs,
  config,
  ...
}:

{

  home.sessionVariables.AMP_DISABLE_AMP_COAUTHOR_TRAILER = "1";

  imports = [
    ./amp.nix
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
    ./pi.nix
  ];

}
