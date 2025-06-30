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
      signByDefault = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINKDCTdkwQIPBPTq4hCkxPhOEDzMfG3dCScdZE5ychiK";
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
      gpg = {
        format = "ssh";
        ssh = {
          program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        };
      };
      commit = {
        gpgsign = true;
      };
    };
  };
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Include ~/.ssh/1Password/config
      Host *
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      # Host 100.111.103.119
      #   HostName 100.111.103.119
      #   User mira
      #   IdentityFile ~/.ssh/keys/mira-mini-1.pub
      #   IdentitiesOnly yes
    '';
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  };

  imports = [
    ../../home/base
    ../../home/darwin
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
