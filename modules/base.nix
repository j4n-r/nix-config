{
  pkgs,
  ...
}:
{
  services.tailscale.enable = true;
  
  nix.settings.extra-substituters = [
    "http://netcache:5000"
    "https://nix-community.cachix.org"
     "https://devenv.cachix.org"
  ];
  nix.settings.extra-trusted-public-keys = [
    "netcache-1:v6JEdkx0xERSZ0RqRTJZvZBVs7e1Tvl4CbXSjIa664g="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
     "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw"
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
