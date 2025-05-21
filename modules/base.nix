{
  pkgs,
  ...
}:
{
  #programs.ssh.startAgent = true;

  services.tailscale.enable = true;

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
  home-manager.backupFileExtension = "backup";
  environment.systemPackages = with pkgs; [
    home-manager
    neovim
    fish
    git
    tldr
    starship

    zip
    unzip
    xz
    btop
    ripgrep
    fd

    wget
    curl
    nmap

    file
    findutils
    which
    tree

    spotify
    zathura
  ];
}
