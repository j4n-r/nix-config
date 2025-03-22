{ ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };

      # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.

      listener = [
        {
          timeout = 550;
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
          on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
        }
        {
          timeout = 2600;
          on-timeout = "systemctl suspend"; # suspend pc
        }
        {
          timeout = 650;
          on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
        }
        {
          timeout = 550;
          on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
        }
      ];
    };
  };
}
