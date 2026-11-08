{ inputs, pkgs, ... }:

{
  imports = [ inputs.niri.nixosModules.binary-cache ];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  programs.steam.enable = true;

  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  # Battery information provider used by DankMaterialShell.
  services.upower.enable = true;

  # Lets the DMS dankscale plugin run tailscale up/down, exit nodes etc. without root.
  services.tailscale.extraSetFlags = [ "--operator=j4n-r" ];

  # Long-lived access token for the DMS homeAssistantMonitor plugin.
  sops.secrets."home-assistant-token" = {
    sopsFile = ../../secrets/home-assistant.yaml;
    mode = "0400";
    owner = "j4n-r";
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  # API token for the local DMS togglTrack plugin.
  sops.secrets."toggl-api-token" = {
    sopsFile = ../../secrets/toggl.yaml;
    mode = "0400";
    owner = "j4n-r";
  };

    dumpcap.enable = true;
    usbmon.enable = true;
  };

  programs.qgroundcontrol.enable = true;
  # optional if you’ll use serial radios / autopilots later:
  services.udev.packages = [ pkgs.qgroundcontrol ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.EDITOR = "nvim";
  environment.sessionVariables.VISUAL = "nvim";

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

    typora
    obsidian
    marktext
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

    bitwarden-cli

    usbutils

    texlive.combined.scheme-full
    prismlauncher
    mcpelauncher-ui-qt
  ];
}
