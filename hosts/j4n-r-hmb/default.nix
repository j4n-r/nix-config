{ inputs, pkgs, ... }:

let
  opencode2 =
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2;
in

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
    # Compressed RAM cache in front of the swapfile; the shrinker moves cold pages to disk.
    kernelParams = [
      "zswap.enabled=1"
      "zswap.shrinker_enabled=1"
    ];
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

  # Keep the laptop awake when the lid is closed.
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # Keep the OpenCode server reachable: disallow systemd sleep states even if
  # a desktop app explicitly requests one. Shutdown/reboot remain available.
  systemd.sleep.settings.Sleep = {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowHybridSleep = "no";
    AllowSuspendThenHibernate = "no";
  };

  # Only reachable over the Tailscale interface, not the LAN.
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  systemd.services.opencode-server = {
    description = "OpenCode server";

    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      User = "j4n-r";
      WorkingDirectory = "/home/j4n-r";
      Environment = [
        "HOME=/home/j4n-r"
        "USER=j4n-r"
        "LOGNAME=j4n-r"
        "PATH=/run/current-system/sw/bin:/home/j4n-r/.nix-profile/bin"
      ];

      ExecStart = "${opencode2}/bin/opencode2 serve --service --hostname 0.0.0.0 --port 4096";

      Restart = "always";
      RestartSec = "5s";
    };
  };

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
    # Start user services (the Amp runner) at boot, without a login session.
    linger = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "i2c"
      "docker"
      "wireshark"
      "dialout"
    ];
    packages = with pkgs; [ ];
  };

  nix.settings.trusted-users = [
    "j4n-r"
    "root"
  ];
  system.stateVersion = "24.11";

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
