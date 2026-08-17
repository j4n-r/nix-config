{ pkgs, ... }:

{
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  programs.niri.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

  programs.qgroundcontrol.enable = true;
  # optional if you’ll use serial radios / autopilots later:
  services.udev.packages = [ pkgs.qgroundcontrol ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.EDITOR = "emacs -nw";
  environment.sessionVariables.VISUAL = "emacs -nw";

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = [
      pkgs.obs-studio-plugins.droidcam-obs
    ];
  };
  programs.droidcam.enable = true;

  environment.systemPackages = with pkgs; [
    xhost
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    discord-ptb
    networkmanagerapplet
    ghostty
    appimage-run
    remmina
    #rustdesk
    bruno
    yaak
    seadrive-gui

    obsidian
 
    xwayland-satellite
    pwvucontrol
    playerctl # used for spotify scripts
    rofi
    wl-clipboard
    waybar
    libnotify
    thunar
    vial

    gtk3
    gtk4
    nwg-look
    brightnessctl

    spotify
    zathura

    vlc

    bitwarden-desktop
    bitwarden-cli

    usbutils

    texlive.combined.scheme-full
    prismlauncher
    mcpelauncher-ui-qt
  ];
}
