{ config, pkgs, ... }:

let
  hyprlandMonitorConfig = ''
    monitor=eDP-1,1920x1080,3440x0,1 
    monitor=DP-1,3440x1440,0x0,1
    monitor=DP-2,1920x1200,0x0,1

    workspace=1,monitor:DP-1
    workspace=2,monitor:DP-1
    workspace=3,monitor:DP-1
    workspace=4,monitor:DP-1
    workspace=5,monitor:DP-1
    workspace=6,monitor:DP-1
  '';
in
{
  home.username = "j4n-r";
  home.homeDirectory = "/home/j4n-r";

  programs.git = {
    enable = true;
    userName = "j4n-r";
    userEmail = "jan.ruegge@gmail.com";
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
