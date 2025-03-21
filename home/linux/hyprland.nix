{ config , pkgs , ... } :

{
  environment.SystemPackages = with pkgs; [
    hypridle
    hyprpaper
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
