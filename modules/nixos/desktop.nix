{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    ghostty
    swaybg
    hyprpaper
    hypridle
    hyprlock
    yaak # api cliennt

    pwvucontrol
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

    vlc

    bitwarden-desktop
    bitwarden-cli

    usbutils

    texlive.combined.scheme-full

  ];
}
