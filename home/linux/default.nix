{ pkgs, ... }:

{
  imports = [
    ./hypr/hyprland.nix
    ./hypr/hyprpaper.nix
    ./hypr/hypridle.nix
    ./hypr/hyprlock.nix
    ./waybar/waybar.nix
    ./gtk.nix
  ];
  home.packages = with pkgs; [
  ];
}
