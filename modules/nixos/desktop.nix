{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    hyprpaper
    hypridle
    hyprlock
    playerctl # used for spotify scripts
    google-chrome
    overskride # bluetooth gui
  ];
}
