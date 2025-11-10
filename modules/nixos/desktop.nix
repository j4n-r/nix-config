{ config, pkgs, ... }:

{
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  programs.hyprland.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
    dumpcap.enable = true;
    usbmon.enable = true;
  };


  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
    ];
  };
  programs.droidcam.enable = true;


  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    discord-ptb
    networkmanagerapplet
    ghostty
    swaybg
    hyprpaper
    hypridle
    hyprlock
    hyprshot
    hyprpicker
    yaak

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
