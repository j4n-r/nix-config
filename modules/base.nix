{
  pkgs,
  ...
}:
{
  #programs.ssh.startAgent = true;

  services.tailscale.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.netbird.clients.wt0 = {
    port = 51821;
    ui.enable = true;
    openFirewall = true;
    openInternalFirewall = true;
  };


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
  home-manager.backupCommand = ''
    mv -f "$1" "$1.backup"
  '';
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
    just
    gnumake

    gh

    acpi

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
    perf
    flamegraph
    lazydocker

    ffmpeg

    file
    findutils
    which
    tree
    man-pages
    man-pages-posix
    liburing
    #linux-manual
  ];
}
