{ ... }:

{
  home.username = "j4n-r";
  home.homeDirectory = "/home/j4n-r";

  programs.git = {
    enable = true;
    userName = "j4n-r";
    userEmail = "jan.rueggeberg@pm.me";

    signing = {
      signByDefault = true;
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRBdapdAkHgPWcWvZudEeNIbecVFCEtvQy09GD+88b7";
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

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
  };
  programs.ssh = {
    enable = true;
    extraConfig = ''
Host gitea-rpi
    HostName 100.94.200.120
    User git
    IdentitiesOnly yes
Host u505154.your-storagebox.de
    IdentityFile ~/.ssh/Hetzner_Backup_Storage_Box.pub
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
