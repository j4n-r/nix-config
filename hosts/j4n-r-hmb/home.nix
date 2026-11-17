{
  pkgs,
  inputs,
  config,
  ...
}:

{
  home.username = "j4n-r";
  home.homeDirectory = "/home/j4n-r";

  # Pin only Hex to the laptop's digital mic; every other app keeps the system
  # default input (the AirPods for calls). Hex records through PipeWire's ALSA
  # plugin, which sends the stream to PIPEWIRE_NODE instead of the default.
  systemd.user.services.hex.Service.Environment = [
    "PIPEWIRE_NODE=hex_mic"
  ];

  # The digital mic's left channel is stuck at a constant offset and its right
  # channel is quiet (speech around -54 dBFS), so Hex's speech detector drops
  # short dictations. This source takes only the right channel and adds 18 dB.
  # PipeWire reads it at startup: systemctl --user restart pipewire
  xdg.configFile."pipewire/pipewire.conf.d/90-hex-mic.conf".text = ''
    context.modules = [
      { name = libpipewire-module-filter-chain
        args = {
          node.description = "Hex Mic"
          media.name = "Hex Mic"
          audio.channels = 1
          audio.position = [ MONO ]
          filter.graph = {
            nodes = [
              { type = builtin name = gain label = mixer control = { "Gain 1" = 8.0 } }
            ]
            inputs = [ "gain:In 1" ]
            outputs = [ "gain:Out" ]
          }
          capture.props = {
            node.name = "capture.hex_mic"
            audio.position = [ FR ]
            stream.dont-remix = true
            node.passive = true
            target.object = "alsa_input.pci-0000_03_00.6.HiFi__Mic1__source"
          }
          playback.props = {
            node.name = "hex_mic"
            media.class = Audio/Source
          }
        }
      }
    ]
  '';

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
      # Decrypted by sops-nix at boot.
      key = "/run/secrets/git-signing-key";
      # ssh-keygen -Y sign prefers the agent when it holds the same key, which
      # makes Bitwarden ask for approval on every commit. Sign from the file.
      signer = toString (
        pkgs.writeShellScript "ssh-keygen-no-agent" ''
          unset SSH_AUTH_SOCK
          exec ${pkgs.openssh}/bin/ssh-keygen "$@"
        ''
      );
    };

    settings = {
      init = {
        defaultBranch = "main";
      };
      # Public half of /run/secrets/git-signing-key, so git can verify signatures.
      gpg.ssh.allowedSignersFile = toString (
        pkgs.writeText "git-allowed-signers" ''
          jan.rueggeberg@pm.me ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDEg2nmtDqX7L73SCGOv8RsWY+OKPp1hf0Cm0LW4OU6S
        ''
      );
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

  # delta: syntax-highlighting diff pager (used by git diff and lazygit)
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      # keep plain; lazygit passes its own flags ("delta --dark --paging=never")
      navigate = true;
      line-numbers = true;
      side-by-side = true;
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never --side-by-side=false";
        };
        diffContextSize = 6;
      };
    };
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
  };
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
        # No userKnownHostsFile here: ssh keeps the first value it reads, and this block
        # comes first, so it would override every alias's own file. ~/.ssh/known_hosts is
        # OpenSSH's default anyway.
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

  # Headless Amp runner so threads can be started on this PC from ampcode.com
  # and the iOS app. Starts at boot (user lingering is enabled in default.nix).
  systemd.user.services.amp-runner = {
    Unit = {
      Description = "Amp runner (amp --no-tui)";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      WorkingDirectory = "%h";
      ExecStart = builtins.concatStringsSep " " [
        "/run/current-system/sw/bin/amp --no-tui"
        "--runner-id j4n-r-hmb"
        "--discover-dirs=%h/dev"
        "--discover-dirs=%h/arrivo"
        "--dir %h/nix-config"
        "--dir %h/me"
        "--dir %h/vault"
        "--remote-control-terminal"
      ];
      # User services get a minimal PATH; give threads the same tools as a login shell.
      Environment = [
        "PATH=/run/wrappers/bin:%h/.nix-profile/bin:/etc/profiles/per-user/j4n-r/bin:/run/current-system/sw/bin"
        "SSH_AUTH_SOCK=%h/.bitwarden-ssh-agent.sock"
      ];
      Restart = "always";
      RestartSec = 10;
    };
    Install.WantedBy = [ "default.target" ];
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
