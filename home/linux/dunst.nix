{ pkgs, ... }:
{

  services.dunst = {
    enable = true;
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
    # https://github.com/d2718nis/rose-pine-dunst
    settings = {
      global = {
        width = 400;
        offset = "8x8";

        progress_bar_min_width = 380;
        progress_bar_max_width = 380;
        progress_bar_corner_radius = 2;

        padding = 10;
        horizontal_padding = 10;
        frame_width = 1;
        gap_size = 8;
        font = "Monospace 10";

        icon_theme = "rose-pine-icons";
        enable_recursive_icon_lookup = true;
        corner_radius = 2;

        background = "#26233a";
        foreground = "#e0def4";
      };

      urgency_low = {
        background = "#26273d";
        highlight = "#31748f";
        frame_color = "#31748f";
        default_icon = "dialog-information";
        format = "<b><span foreground='#31748f'>%s</span></b>\n%b";
      };

      urgency_normal = {
        background = "#362e3c";
        highlight = "#f6c177";
        frame_color = "#f6c177";
        default_icon = "dialog-warning";
        format = "<b><span foreground='#f6c177'>%s</span></b>\n%b";
      };

      urgency_critical = {
        background = "#35263d";
        highlight = "#eb6f92";
        frame_color = "#eb6f92";
        default_icon = "dialog-error";
        format = "<b><span foreground='#eb6f92'>%s</span></b>\n%b";
      };
    };
  };
}
