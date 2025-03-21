{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "j4n-r-tp6"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  hardware.bluetooth.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.j4n-r = {
    isNormalUser = true;
    description = "Jan Rueggeberg";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # $ nix search wget
  xdg.portal.enable =true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk];
  security.rtkit.enable =true;
  services.pipewire = {
    enable = true;
    alsa.enable =true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable=true;
    };

  system.stateVersion = "24.11"; 

}
