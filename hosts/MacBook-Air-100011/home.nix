{ config, pkgs, ... }:

{
  home.username = "jr";
  home.homeDirectory = "/Users/jr";

  home.sessionPath = [ "/run/current-system/sw/bin" ];

  programs.git = {
    enable = true;
    userName = "Jan Rueggeberg";
    userEmail = "jan.rueggeberg@mirantus.com";

    signing = {
      format = "ssh";
      signByDefault = true;
      key = "~/.ssh/id_ed25519.pub";
    };

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
