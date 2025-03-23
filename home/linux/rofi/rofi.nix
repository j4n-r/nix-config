{
  programs.rofi = {
    enable = true;

    extraConfig = {
      modes = "drun";
      font = "JetBrainsMono 12";
      location = 0;
      yoffset = 0;
      xoffset = 0;
      fixed-num-lines = true;
      show-icons = true;
      terminal = "ghostty";
      icon-theme = "rose-pine";
      #  drun-match-fields: "name,generic,exec,categories,keywords";
      drun-display-format = "{name}";
      sort = true;
      sorting-method = "normal";
      case-sensitive = false;
      cycle = true;
      hover-select = true;
      # eh: 1; row height
      auto-select = false;
      matching = "fuzzy";
      transient-window = true;
      # m: "-5"; - monitor
      # filter: ;
      # dpi: -1;
      # threads: 0;
      # scroll-method: 0;
      # window-format: "{w}    {c}   {t}";
      # click-to-exit: true;
      # max-history-size: 25;
      # combi-hide-mode-prefix: false;
      # combi-display-format: "{mode} {text}";
      # matching-negate-char: '-' # unsupported ;
      # cache-dir: ;
      # window-thumbnail: false;
      # drun-use-desktop-cache: false;
      # drun-reload-desktop-cache: false;
      # normalize-match: false;
      # steal-focus: false;
      # application-fallback-icon: ;
      # refilter-timeout-limit: 8192;
      # xserver-i300-workaround: false;
      # pid: "/run/user/1000/rofi.pid";
      display-drun = "Search:";
    };

    theme = "~/nix-config/home/linux/rofi/rofiTheme";
  };
}
