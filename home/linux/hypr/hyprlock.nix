{ ... }:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        monitor = "";
        path = "screenshot";
        blur_passes = 3;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };
      # GENERAL
      general = {
        no_fade_in = false;
        grace = 0;
        disable_loading_bar = true;
      };
      # INPUT FIELD
      input-field = [
        {
          monitor = "";
          size = "250, 60";
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(0, 0, 0, 0.5)";
          font_color = "rgb(200, 200, 200)";
          fade_on_empty = false;
          font_family = "JetBrains Mono Nerd Font";
          placeholder_text = ''<i><span foreground="##cdd6f4"> Password </span></i>'';
          hide_input = false;
          position = "0, -300";
          halign = "center";
          valign = "center";
        }
      ];
      # TIME
      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
          color = "rgba(255, 255, 255, 0.6)";
          font_size = 120;
          font_family = "JetBrains Mono Nerd Font ExtraBold";
          position = "0, -300";
          halign = "center";
          valign = "top";
        }
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%A, %d.%m.%y")"'';
          color = "rgba(255, 255, 255, 0.6)";
          font_size = 25;
          font_family = "JetBrains Mono Nerd Font";
          position = "0, -500";
          halign = "center";
          valign = "top";
        }
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(~/nix-config/scripts/linux/now-playing)"'';
          color = "rgba(255, 255, 255, 0.6)";
          font_size = 16;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 200";
          halign = "center";
          valign = "bottom";
        }
        {
          monitor = "";
          text = "Solve actual problems, not imaginary ones";
          color = "rgba(255, 255, 255, 0.7)";
          font_size = 18;
          font_family = "JetBrains Mono Nerd Font";
          position = "0, 70";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}
