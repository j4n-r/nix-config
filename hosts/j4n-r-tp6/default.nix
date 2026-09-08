{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.dank-greeter.nixosModules.default
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  virtualisation.docker.enable = true;

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  networking.hostName = "j4n-r-tp6";

  programs.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/j4n-r";
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024; # 32 GB
    }
  ];

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
