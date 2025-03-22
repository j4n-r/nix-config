{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    hyprpaper
    hypridle
    hyprlock

    playerctl # used for spotify scripts
    wl-clipboard
    wofi
    dunst
    waybar
    libnotify
    grim
    slurp
    google-chrome
    overskride # bluetooth gui
    xfce.thunar

    gtk3
    gtk4
    nwg-look

  ];
}
