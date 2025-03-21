{ pkgs, ...} :

{
  imports  =[ ./hyprland/hyprland.nix ./fish.nix ./waybar/waybar.nix];
  home.packages = with pkgs; [
    wofi 
    dunst 
    waybar
    libnotify
  ];
}
