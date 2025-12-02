{
  pkgs,
  ...
}:
{
  #programs.ssh.startAgent = true;

  services.tailscale.enable = true;
  services.gnome.gnome-keyring.enable = true;

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
    fishPlugins.bass
    fish
    git
    tldr
    starship
    zellij
    bat
    fzf
    rclone
    jq

    zip
    unzip
    xz
    btop
    ripgrep 
    fd 
    eza 
    zoxide
    xh 
    dust
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
    liburing
    linux-manual

    spotify
    zathura
  ];
}
