{ pkgs, ... }:
let
  ghostty-mock = pkgs.writeShellScriptBin "gostty-mock" ''
    true
  '';
in
{
  programs.ghostty = {
    enable = true;
    package = ghostty-mock; # Set explicitly to null, as it is managed externally
    enableFishIntegration = true;
    settings = {

      theme = "rose-pine";
      # background-opacity = 0.8;
      window-padding-x = 8;
      window-padding-y = 8;
      window-decoration = false;
      resize-overlay = "never";
      font-size = 10;
      mouse-hide-while-typing = true;
      gtk-tabs-location = "bottom";

      keybind = [
        "ctrl+g>n=new_tab"
        "ctrl+g>v=new_split:right"
        "ctrl+g>h=goto_split:left"
        "ctrl+g>l=goto_split:right"
        "ctrl+g>j=next_tab"
        "ctrl+g>k=previous_tab"
        "ctrl+g>x=close_surface"
        "global:super+alt+t=toggle_quick_terminal"
      ];
    };
  };
}
