{
  pkgs,
  ...
}:
{
  programs.ssh.startAgent = true;

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
    ghostty
    neovim
    fish
    git
    tldr
    starship

    megacmd
    megasync

    zip
    xz
    btop
    ripgrep

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
