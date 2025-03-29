{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # udev rules for vial
  services.udev.extraRules = ''
    # beekeeb Piantor Pro
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="beeb", ATTRS{idProduct}=="0002", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  networking.hostName = "j4n-r-hmb";
  services.getty.autologinUser = "j4n-r";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  # boot.kernelModules = [
  #   "i2c-dev"
  #   "i2c-piix4"
  #   "ddcci"
  # ];

  # used for ddcutils
  hardware.i2c.enable = true;

  users.users.j4n-r = {
    isNormalUser = true;
    description = "Jan Rueggeberg";
    extraGroups = [
      "networkmanager"
      "wheel"
      "i2c"
    ];
    packages = with pkgs; [ ];
  };

  system.stateVersion = "24.11";

}
