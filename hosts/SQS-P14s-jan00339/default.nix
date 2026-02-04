{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.dms.nixosModules.greeter
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  virtualisation.docker.enable = true;

  powerManagement.enable = true;
  services.tlp.enable = true;

  networking.hostName = "SQS-P14s-jan00339";


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

  nix.settings.trusted-users = [
    "j4n-r"
    "root"
  ];
  system.stateVersion = "25.11";

}
