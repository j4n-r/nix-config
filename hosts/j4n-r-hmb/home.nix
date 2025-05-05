{ config, pkgs, ... }:

let

  hyprlandMonitorConfig = ''
    monitor=eDP-1,2520x1680,3440x0,1 
    monitor=DP-1,3440x1440@100,0x0,1

    workspace=1,monitor:DP-1, default:true
    workspace=2,monitor:DP-1
    workspace=3,monitor:DP-1
    workspace=4,monitor:DP-1
    workspace=5,monitor:DP-1
    workspace=6,monitor:DP-1
  '';
in
# hyprlandMonitorConfig = ''
#   monitor=eDP-1,2520x1680,3440x0,1
#   monitor=DP-3,3440x1440@100,0x0,1
#   monitor=DP-4,1920x1080,860x-1080,1
#   workspace=1,monitor:DP-3, default:true
#   workspace=2,monitor:DP-3
#   workspace=3,monitor:DP-3
#   workspace=4,monitor:DP-4
#   workspace=5,monitor:DP-4
#   workspace=6,monitor:DP-4
# '';
{
  home.username = "j4n-r";
  home.homeDirectory = "/home/j4n-r";

  programs.git = {
    enable = true;
    userName = "j4n-r";
    userEmail = "jan.ruegge@gmail.com";

    signing = {
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRBdapdAkHgPWcWvZudEeNIbecVFCEtvQy09GD+88b7";
      signByDefault = true;
    };

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
      core = {
        editor = "nvim";
      };
      color = {
        ui = true;
      };
      github = {
        user = "j4n-r";
      };
    };
  };

  imports = [
    (import ../../home/linux {
      config = config;
      pkgs = pkgs;
      hyprlandMonitorConfig = hyprlandMonitorConfig;
    })
    ../../home/base
  ];
  wayland.windowManager.hyprland = {
    enable = true;

  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
