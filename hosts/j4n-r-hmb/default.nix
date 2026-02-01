{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.dms.nixosModules.greeter
  ];
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024; # 32 GB
    }
  ];

  powerManagement.enable = true;
  services.tlp.enable = true;

  virtualisation.docker.enable = true;

  # udev rules for vial
  services.udev.extraRules = ''
    # beekeeb Piantor Pro
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="beeb", ATTRS{idProduct}=="0002", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  networking.hostName = "j4n-r-hmb";

  # services.getty.autologinUser = "j4n-r";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

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

  # boot.kernelModules = [
  #   "i2c-dev"
  #   "i2c-piix4"
  #   "ddcci"
  # ];

  # used for ddcutils
  hardware.i2c.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
    ];
  };

  users.users.j4n-r = {
    isNormalUser = true;
    description = "Jan Rueggeberg";
    extraGroups = [
      "networkmanager"
      "wheel"
      "i2c"
      "docker"
      "wireshark"
    ];
    packages = with pkgs; [ ];
  };

  nix.settings.trusted-users = [
    "j4n-r"
    "root"
  ];
  system.stateVersion = "24.11";

  systemd.timers."rclone-sync-books" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "30m";
      Unit = "rclone-sync-books.service";
    };
  };

  # systemd.services."rclone-sync-books" = {
  #   script = ''
  #     set -eu
  #     ${pkgs.rclone}/bin/rclone bisync proton:books /home/j4n-r/proton-drive/books
  #   '';
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "j4n-r";
  #   };
  # };

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

}
