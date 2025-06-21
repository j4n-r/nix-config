{
  programs.rofi = {
    enable = true;

    extraConfig = {
      modes = "drun";
      font = "JetBrainsMono 14";
      location = 0;
      yoffset = 0;
      xoffset = 0;
      fixed-num-lines = true;
      show-icons = true;
      terminal = "ghostty";
      icon-theme = "rose-pine";
      drun-display-format = "{name}";
      sort = true;
      sorting-method = "normal";
      case-sensitive = false;
      cycle = true;
      hover-select = false;
      auto-select = false;
      matching = "normal";
      transient-window = true;
      display-drun = "Search:";
    };

    theme = "~/nix-config/home/linux/rofi/rofiTheme";
  };
}
