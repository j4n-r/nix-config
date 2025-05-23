{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.docker.enable = true;

  networking.hostName = "j4n-r-pi5";
  services.getty.autologinUser = "j4n-r";

  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
    PermitRootLogin = lib.mkForce "no";
  };

  # used for ddcutils
  hardware.i2c.enable = true;

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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ4HY9z59TQJwwYrqU/FYSMb0dvUSFuz8SpHrZ7aSa3M"
    ];
  };

  system.stateVersion = "24.11";

}
