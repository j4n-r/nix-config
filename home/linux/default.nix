{
  hyprlandMonitorConfig,
  pkgs,
  config,
  ...
}:

{
  imports = [
    (import ./hypr/hyprland.nix { hyprlandMonitorConfig = hyprlandMonitorConfig; })
    ./hypr/hypridle.nix
    ./hypr/hyprlock.nix
    ./waybar/waybar.nix
    ./gtk.nix
    ./rofi/rofi.nix
    ./dunst.nix
    ./chromium.nix
  ];

  # changed to use EurKey layout for now (use AltGr to write umlaut (altgr + 5 for €)

  # home.file."${config.home.homeDirectory}/.config/xkb/symbols/umlauteKeymap" = {
  #   enable = true;
  #   text = ''
  #     default partial alphanumeric_keys
  #     xkb_symbols "basic" {
  #     	include "us(altgr-intl)"
  #     	include "level3(caps_switch)"
  #     	name[Group1] = "English (US, international with German umlaut)";
  #     	key <AD03> { [ e, E, EuroSign, cent ] };
  #     	key <AD07> { [ u, U, udiaeresis, Udiaeresis ] };
  #     	key <AD09> { [ o, O, odiaeresis, Odiaeresis ] };
  #     	key <AC01> { [ a, A, adiaeresis, Adiaeresis ] };
  #     	key <AC02> { [ s, S, ssharp ] };
  #     };
  #   '';
  # };

  home.pointerCursor = {
    name = "BreezeX-RosePineDawn-Linux";
    package = pkgs.rose-pine-cursor;
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  };
  services.megasync.enable = true;

  home.packages = with pkgs; [
  ];
}
