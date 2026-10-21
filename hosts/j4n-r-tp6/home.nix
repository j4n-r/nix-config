{ config, pkgs, ... }:

{
  home.username = "j4n-r";
  home.homeDirectory = "/home/j4n-r";

  programs.git = {
    enable = true;
    # Typst PDFs contain no NUL bytes in their header, so git would diff them
    # as text; that dumps raw bytes into Magit and triggers coding prompts.
    attributes = [ "*.pdf binary" ];
    settings = {
      user = {
        name = "j4n-r";
        email = "jan.rueggeberg@pm.me";
      };
    };

    signing = {
      signByDefault = true;
      format = "ssh";
      # Decrypted by sops-nix at boot; Git does not use the Bitwarden SSH agent for signing.
      key = "/run/secrets/git-signing-key";
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
  home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
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
    };
    extraConfig = ''
      Include /etc/ssh/ssh_config.d/*.conf
      Host 100.94.200.120
         IdentityFile ~/.ssh/Forgejo.pub
         IdentityFile ~/.ssh/ssh_j4n-rpi5.pub
         IdentitiesOnly yes
      Host u505154.your-storagebox.de
         IdentityFile ~/.ssh/Hetzner_Backup_Storage_Box.pub
         IdentitiesOnly yes
      Host 188.245.240.115
         IdentityFile ~/.ssh/SWE_HWR.pub
         IdentitiesOnly yes
      Host codeberg.org
         IdentityFile ~/.ssh/Codeberg.pub
         AddressFamily inet
         IdentitiesOnly yes
      Host netcache 152.53.17.131
         HostName 100.95.163.72
         User root
         IdentityFile ~/.ssh/Netcup_VPS_netcache.pub
         AddressFamily inet
         IdentitiesOnly yes
      Host hetzner 91.99.52.144
         IdentityFile ~/.ssh/Root_Hetzner_Coolify_Server.pub
         User root
         IdentitiesOnly yes
    '';
  };

  imports = [
    ../../home/linux
    ../../home/base
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
