{ inputs, ... }:
{
  imports = [
    inputs.sherlock.homeManagerModules.default
  ];

  programs.sherlock = {
    enable = true;
    settings = {
      config = {
        appearance = {
          width = 800;
          height = 450;
          icon_paths = [ "~/nix-config/icons" ];
        };
        daemonize = true;
        debug = {
          try_suppress_warnings = true;
        };
        binds.modifier = "control";

      };
      ignore = ''
        Avahi*
      '';
      launchers = [
        {
          name = "Calculator";
          type = "calculation";
          args = {
            capabilities = [
              "calc.math"
              "calc.units"
            ];
          };
          priority = 1;
        }
        {
          name = "Clipboard";
          type = "clipboard-execution";
          args = {
            capabilities = [
              "url"
              "colors.hex"
              "colors.rgb"
              "colors.hsl"
              "calc.math"
              "calc.lengths"
              "calc.weights"
              "calc.temperatures"
            ];
          };
          priority = 1;
        }

        {
          name = "App Launcher";
          alias = "app";
          type = "app_launcher";
          args = { };
          priority = 2;
          home = "Home";
        }
        {
          name = "Kill Process";
          alias = "kp";
          type = "process";
          args = { };
          priority = 0;
        }

        {
          name = "Power Management";
          alias = "pm";
          type = "command";
          args = {
            commands = {
              "Shutdown" = {
                icon = "system-shutdown";
                icon_class = "reactive";
                exec = "systemctl poweroff";
                search_string = "Poweroff;Shutdown";
              };
              "Sleep" = {
                icon = "system-suspend";
                icon_class = "reactive";
                exec = "systemctl suspend";
                search_string = "Sleep;";
              };
              "Lock" = {
                icon = "system-lock-screen";
                icon_class = "reactive";
                exec = "systemctl suspend & swaylock";
                search_string = "Lock Screen;";
              };
              "Reboot" = {
                icon = "system-reboot";
                icon_class = "reactive";
                exec = "systemctl reboot";
                search_string = "reboot;restart";
              };
              "Log Oout" = {
                icon = "system-log-out";
                icon_class = "reactive";
                exec = "hyprctl dispatch exit";
                search_string = "logout;exit";
              };
            };
          };
          priority = 5;
        }

        {
          name = "Web Search";
          display_name = "Google Search";
          tag_start = "{keyword}";
          tag_end = "{keyword}";
          alias = "gg";
          type = "web_launcher";
          args = {
            search_engine = "google";
            icon = "google";
          };
          priority = 100;
        }
        {
          name = "Claude";
          display_name = "Claude-LLM";
          tag_start = "{keyword}";
          tag_end = "{keyword}";
          alias = "!c";
          type = "web_launcher";
          args = {
            search_engine = "https://claude.ai/new?q={keyword}";
            icon = "claude";
          };
          priority = 100;
        }
        {
          name = "ChatGPT";
          display_name = "ChatGPT";
          tag_start = "{keyword}";
          tag_end = "{keyword}";
          alias = "!g";
          type = "web_launcher";
          args = {
            search_engine = "https://chatgpt.com/?q={keyword}";
            icon = "openai";
          };
          priority = 100;
        }
        {
          name = "Moodle";
          display_name = "Moodle";
          tag_start = "{keyword}";
          tag_end = "{keyword}";
          alias = "md";
          type = "web_launcher";
          args = {
            search_engine = "https://moodle.hwr-berlin.de/my/";
            icon = "hwr-logo";
          };
          priority = 100;
        }
        {
          name = "Debug";
          type = "debug";
          alias = "debug";
          args = {
            commands = {
              "Show Errors" = {
                icon = "sherlock-process";
                exec = "show_errors";
                search_string = "debug;errors";
              };
              "Clear Cache" = {
                icon = "sherlock-process";
                exec = "clear_cache";
                search_string = "clear;cache;";
              };
              "Reset App Counts" = {
                icon = "sherlock-process";
                exec = "reset_counts";
                search_string = "reset;clear;counts;appcounts";
              };
            };
          };
          priority = 0;
        }
      ];
      style = ''
        :root {
            --background: hsl(247, 23%, 15%);
            --foreground: hsl(249, 15%, 28%);
            --text: hsl(245, 50%, 91%);
            --border: hsl(248, 21%, 26%);
        }
      '';
    };
  };
}
