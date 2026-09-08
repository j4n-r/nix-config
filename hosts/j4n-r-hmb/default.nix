{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.dank-greeter.nixosModules.default
  ];
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    extraModprobeConfig = ''
      options btusb enable_autosuspend=0
    '';
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024; # 32 GB
    }
  ];

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  virtualisation.docker.enable = true;

  # udev rules for vial
services.udev.extraRules = ''
  # beekeeb Piantor Pro / Vial
  KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="beeb", ATTRS{idProduct}=="0002", MODE="0660", GROUP="users", TAG+="uaccess"

  # Beekeeb Toucan2 / ZMK Studio
  SUBSYSTEM=="tty", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="615e", MODE="0660", TAG+="uaccess"

  # The Realtek Bluetooth adapter drops BLE HID connections after autosuspend.
  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1358", ATTR{idProduct}=="c123", TEST=="power/control", ATTR{power/control}="on"
'';

  networking.hostName = "j4n-r-hmb";

  # services.getty.autologinUser = "j4n-r";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.dms-greeter = {
    enable = true;
    compositor.name = "niri";
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

    services.sunshine = {
    enable = true;
    autoStart = true;  # optional: starts Sunshine automatically on login
    capSysAdmin = true;
    openFirewall = true;
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
      "dialout"
      "netbird-wt0"
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
