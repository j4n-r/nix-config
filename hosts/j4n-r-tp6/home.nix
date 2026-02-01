{ config, pkgs, ... }:

{
  home.username = "j4n-r";
  home.homeDirectory = "/home/j4n-r";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "j4n-r";
        email = "jan.rueggeberg@pm.me";
      };
    };

    signing = {
      signByDefault = true;
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRBdapdAkHgPWcWvZudEeNIbecVFCEtvQy09GD+88b7";
    };

    settings = {
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

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
  };
  programs.ssh = {
    enable = true;
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
    extraConfig = ''
Host 188.245.240.115
    IdentityFile ~/.ssh/SWE_HWR.pub
    IdentitiesOnly yes

Host codeberg.org
    IdentityFile ~/.ssh/Codeberg.pub
    IdentitiesOnly yes
'';
  };

  imports = [
    ../../home/linux
    ../../home/base
  ];
  wayland.windowManager.hyprland = {
    enable = true;

  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
