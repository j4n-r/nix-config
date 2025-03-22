{ pkgs, ... }:

{
  imports = [
    ./hypr/hyprland.nix
    ./hypr/hyprpaper.nix
    ./hypr/hypridle.nix
    ./hypr/hyprlock.nix
    ./fish.nix
    ./waybar/waybar.nix
  ];
  home.packages = with pkgs; [
    wofi
    dunst
    waybar
    libnotify
  ];
}
