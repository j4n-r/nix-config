{
  pkgs,
  ...
}:
{
  #programs.ssh.startAgent = true;

  services.tailscale.enable = true;

  nix.settings.extra-substituters = [ "http://netcache:5000" ];
  nix.settings.extra-trusted-public-keys = [
    "netcache-1:v6JEdkx0xERSZ0RqRTJZvZBVs7e1Tvl4CbXSjIa664g="
  ];

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
