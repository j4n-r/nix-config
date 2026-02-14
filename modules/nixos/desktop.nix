{ config, pkgs, ... }:

{
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  programs.hyprland.enable = true;
  programs.niri.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins =
      with pkgs.obs-studio-plugins;
      [
      ]
      ++ [
        (
          (pkgs.obs-studio-plugins.droidcam-obs.override {
            ffmpeg_7 = pkgs.ffmpeg;
          }).overrideAttrs
          (prev: {
            version = "2.4.2-unstable-2025-10-14";

            src = pkgs.fetchFromGitHub {
              owner = "dev47apps";
              repo = "droidcam-obs-plugin";
              rev = "161cb95b8dc5fe77185e52a9783dc45c6d137165";
              sha256 = "sha256-3GClykaJjjmasEnSVGU5jnz+xoznaSYTxBz7jkhj0m4=";
            };
          })
        )
      ];
  };
  programs.droidcam.enable = true;

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
    hypridle
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

    xwayland-satellite
    pwvucontrol
    playerctl # used for spotify scripts
    rofi
    wl-clipboard
    waybar
    libnotify
    grim
    slurp
    google-chrome
    xfce.thunar
    vial

    gtk3
    gtk4
    nwg-look
    brightnessctl

    vlc

    bitwarden-desktop
    bitwarden-cli

    usbutils

    texlive.combined.scheme-full
    prismlauncher
    mcpelauncher-ui-qt
    
  ];
}
