{ nixpkgs,  ... } :


let
  abstract ="../../../wallpapers/abstract.jpeg";
in
{
  services.hyprpaper = {
    enable = true;
    settings ={
          preload =
            [ abstract ];

          wallpaper = [
            "eDP-1,${abstract}"
            "DP-1,${abstract}"
            "DP-2,${abstract}"
            "DP-3,${abstract}"
            "DP-4,${abstract}"
            "HDMI-A-1,${abstract}"
          ];
};
};
}
