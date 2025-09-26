{
  ...
}:

{
  programs.waybar = {
    enable = true;

    style = ./style.css;
    settings = [
      {
        layer = "top";
        position = "bottom";
        margin-left = 10;
        margin-right = 10;
        ## margin-top= 10;
        margin-bottom = 10;
        spacing = 1;

        modules-left = [
          "custom/power"
          "hyprland/workspaces"
          "custom/spotify"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "cpu"
          "temperature"
          "memory"
          "battery"
          "disk"
          "pulseaudio"
          "network"
          "tray"
        ];

        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          all-outputs = true;
          format-icons = {
            "1" = " ";
            "2" = "󰛄 ";
            "3" = "󰊠 ";
            "4" = "󰞀 ";
            "5" = " ";
            "6" = " ";
            "7" = "_ ";
          };
        };
        "custom/spotify" = {
          interval = 1;
          exec = "~/nix-config/scripts/linux/now-playing";
          on-click = "~/nix-config/scripts/linux/play-next";
          on-click-right = "~/nix-config/scripts/linux/play-previous";
          escape = true;
        };
        tray = {
          icon-size = 18;
          spacing = 5;
          show-passive-items = true;
        };
        clock = {
          timezone = "Europe/Berlin";
          interval = 60;
          format = "  {:%a %d.%m.  %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        temperature = {
          critical-threshold = 80;
          interval = 2;
          format = " {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
          ];
        };
        cpu = {
          interval = 2;
          format = "  {usage}%";
          tooltip = false;
        };
        memory = {
          interval = 2;
          format = "  {}%";
        };
        disk = {
          interval = 15;
          format = "󰋊 {percentage_used}%";
        };
        network = {
          format-wifi = "  {ipaddr}";
          format-ethernet = "󰌗 {ipaddr}/{cidr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}= {ipaddr}/{cidr}";
        };
        pulseaudio = {
          format = "{icon}  {volume}%";
          format-bluetooth = "{icon}  {volume}% 󰂯";
          format-bluetooth-muted = "󰖁 {icon} 󰂯";
          format-muted = "󰖁 {format_source}";
          format-source = "{volume}% ";
          format-source-muted = " ";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󱡒";
            headset = "󰋎";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pwvucontrol";
        };
        battery = {
          states = {
            warning = 30;
            critical = 1;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂊 {capacity}%";
          format-plugged = "󰂅 {capacity}%";
          format-alt = "{time} {icon}";
          format-full = "󰂅 {capacity}%";
          format-icons = [
            "󰢜"
            "󰢝"
            "󰂊"
          ];
        };

        "custom/power" = {
          format = "{icon}";
          format-icons = "";
        };
      }
    ];
  };
}
