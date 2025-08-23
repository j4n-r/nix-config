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
      window-theme = "ghostty";
      macos-titlebar-style = "tabs";
      window-padding-x = 8;
      window-padding-y = 8;
      font-size = 10;
      mouse-hide-while-typing = true;
      gtk-tabs-location = "bottom";
      resize-overlay = "never";
      keybind = [
        # Tab management with Ctrl+t prefix
        "ctrl+t>n=new_tab"
        "ctrl+t>c=new_tab" # Alternative create tab
        "ctrl+t>l=next_tab" # Next tab
        "ctrl+t>h=previous_tab" # Previous tab
        "ctrl+t>1=goto_tab:1" # Go to tab 1
        "ctrl+t>2=goto_tab:2" # Go to tab 2
        "ctrl+t>3=goto_tab:3" # Go to tab 3
        "ctrl+t>4=goto_tab:4" # Go to tab 4
        "ctrl+t>5=goto_tab:5" # Go to tab 5
        "ctrl+t>6=goto_tab:6" # Go to tab 6
        "ctrl+t>7=goto_tab:7" # Go to tab 7
        "ctrl+t>8=goto_tab:8" # Go to tab 8
        "ctrl+t>9=goto_tab:9" # Go to tab 9
        "ctrl+t>x=close_tab" # Close current tab
        "ctrl+t>q=close_tab" # Alternative close tab

        # Pane management with Ctrl+p prefix
        "ctrl+w>v=new_split:right" # Vertical split (right)
        "ctrl+w>n=new_split:right" # Vertical split (right)
        "ctrl+w>s=new_split:down" # Horizontal split (down)
        "ctrl+w>h=goto_split:left" # Move left
        "ctrl+w>l=goto_split:right" # Move right
        "ctrl+w>j=goto_split:down" # Move down
        "ctrl+w>k=goto_split:up" # Move up
        "ctrl+w>x=close_surface" # Close current pane
        "ctrl+w>z=toggle_split_zoom" # Toggle pane zoom (like tmux)
        "ctrl+w>equal=equalize_splits" # Equalize panes

        # Resize panes
        "ctrl+w>shift+h=resize_split:left,30"
        "ctrl+w>shift+l=resize_split:right,30"
        "ctrl+w>shift+j=resize_split:down,30"
        "ctrl+w>shift+k=resize_split:up,30"

        # Global quick terminal toggle (like your original)
        "global:super+alt+t=toggle_quick_terminal"

        # Additional useful bindings
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
        "ctrl+shift+f=toggle_fullscreen"
        "ctrl+shift+r=reload_config"
        "ctrl++=increase_font_size:1"
        "ctrl+-=decrease_font_size:1"
      ];
    };
  };
}
