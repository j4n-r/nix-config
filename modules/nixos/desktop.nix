{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    swaybg
    hyprpaper
    hypridle
    hyprlock

    playerctl # used for spotify scripts
    rofi-wayland
    wl-clipboard
    dunst
    waybar
    libnotify
    grim
    slurp
    google-chrome
    overskride # bluetooth gui
    xfce.thunar
    vial

    gtk3
    gtk4
    nwg-look
    brightnessctl

    megacmd
    megasync

    bitwarden-desktop
    bitwarden-cli
  ];
}
