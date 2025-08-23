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
  documentation.dev.enable = true;
  home-manager.backupFileExtension = "backup";
  environment.systemPackages = with pkgs; [
    home-manager
    neovim
    vim
    fish
    git
    tldr
    starship
    zellij
    bat
    fcp

    zip
    unzip
    xz
    btop
    ripgrep # better grep
    fd # better find
    eza # better ls
    zoxide # better cd
    xh # http cli
    #disk checker
    du-dust
    dua

    wget
    curl
    nmap
    lazydocker

    file
    findutils
    which
    tree
    man-pages
    man-pages-posix

    spotify
    zathura
  ];
}
