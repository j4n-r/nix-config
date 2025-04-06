
{ config, pkgs, ... }:

{
  home.username = "jr";
  home.homeDirectory = "/home/jr";

  programs.git = {
    enable = true;
    userName = "Jan Rueggeberg";
    userEmail = "jan.rueggeberg@mirantus.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
      core = {
        editor = "emacs";
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
    ../../home/base
    ../../home/darwin
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
