{ pkgs, ...} :

{
  imports  =[ ./hypr/hyprland.nix ./hypr/hyprpaper.nix
              ./fish.nix
              ./waybar/waybar.nix];
  home.packages = with pkgs; [
    wofi 
    dunst 
    waybar
    libnotify
  ];
}
