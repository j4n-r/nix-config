{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  virtualisation.docker.enable = true;

  powerManagement.enable = true;
  services.tlp.enable = true;

  networking.hostName = "j4n-r-tp6";
  # services.getty.autologinUser = "j4n-r";


  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "hyprland"; 
    compositor.customConfig = ''
      # Optional custom compositor configuration
      misc { 
          force_default_wallpaper = 0 # Set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = true # If true disables the random hyprland logo / anime girl background. :(
          disable_splash_rendering = true
          initial_workspace_tracking = 1
      }
      exec-once = hyprctl setcursor BreezeX-RosePineDawn-Linux 32
    '';
    configHome = "/home/j4n-r";
  };

# services.displayManager.defaultSession = "hyprland";

  # used for ddcutils
  hardware.i2c.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
    ];
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.j4n-r = {
    isNormalUser = true;
    description = "Jan Rueggeberg";
    extraGroups = [
      "networkmanager"
      "wheel"
      "i2c"
      "docker"
    ];
    packages = with pkgs; [ ];
  };
  environment.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
    };

  # systemd.timers."rclone-sync-notes" = {
  #   wantedBy = [ "timers.target" ];
  #   timerConfig = {
  #     OnBootSec = "5m";
  #     OnUnitActiveSec = "30m";
  #     Unit = "rclone-sync-notes.service";
  #   };
  # };

  # systemd.services."rclone-sync-notes" = {
  #   script = ''
  #     set -eu
  #     ${pkgs.rclone}/bin/rclone bisync proton:personal/notes/denote /home/j4n-r/notes/
  #   '';
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "j4n-r";
  #   };
  # };

  nix.settings.trusted-users = [
    "j4n-r"
    "root"
  ];
  system.stateVersion = "24.11";

}
