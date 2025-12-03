{ hyprlandMonitorConfig, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      ################
      ### MONITORS ###
      ################

      ${hyprlandMonitorConfig}      

      $base           = 0xff191724
      $surface        = 0xff1f1d2e
      $overlay        = 0xff26233a
      $muted          = 0xff6e6a86
      $subtle         = 0xff908caa
      $text           = 0xffe0def4
      $love           = 0xffeb6f92
      $gold           = 0xfff6c177
      $rose           = 0xffebbcba
      $pine           = 0xff31748f
      $foam           = 0xff9ccfd8
      $iris           = 0xffc4a7e7
      $highlightLow   = 0xff21202e
      $highlightMed   = 0xff403d52
      $highlightHigh  = 0xff524f67
      monitor=,preferred,auto,auto

      # start hyprlock on lid close
      bindl=,switch:on:Lid Switch, exec, hyprlock

      animations {
          enabled = false
      }


      ###################
      ### MY PROGRAMS ###
      ###################

      # Set programs that you use
      $terminal = ghostty
      $fileManager = dolphin
      $menu = rofi -show drun
      $powermenu = ~/nix-config/scripts/linux/powermenu.sh

      #################
      ### AUTOSTART ###
      #################

      exec-once = hyprlock
      exec-once = waybar
      exec-once = nm-applet
      exec-once = blueman-applet
      exec-once = swaybg -o "*" -m "stretch" -i ~/nix-config/wallpapers/abstract.jpeg 
      exec-once = swaync
      exec-once = /usr/lib/polkit-kde-authentication-agent-1
      exec-once = hyprctl setcursor BreezeX-RosePineDawn-Linux 32
      exec-once = [workspace 1 silent] emacs --fullscreen
      exec-once = [workspace 3 silent] ghostty
      exec-once = [workspace 2 silent] /home/j4n-r/AppImages/helium.appimage
      exec-once = [workspace 4 silent; group set always] proton-mail
      exec-once = [workspace 4 silent; group set always] bitwarden
      exec-once = sleep 0.5 && hyprctl dispatch workspace 1


      #############################
      ### ENVIRONMENT VARIABLES ###
      #############################

      # set scaling or gtk apps 
      env = GDK_SCALE, 1
      env = XCURSOR_SIZE, 32

      #####################
      ### LOOK AND FEEL ###
      #####################

      general { 
          gaps_in = 5
          gaps_out = 20

          border_size = 2

          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          col.active_border = $iris
          col.inactive_border = $overlay

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = true

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false

          layout = dwindle
      }

      decoration {
          rounding = 10
      }

      dwindle {
          pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # You probably want this
      }

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc { 
          force_default_wallpaper = 0 # Set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = true # If true disables the random hyprland logo / anime girl background. :(
          initial_workspace_tracking = 1
      }

      group {
          # Group border colors - more subtle
          col.border_active = $iris
          col.border_inactive = $muted
          col.border_locked_active = $rose
          col.border_locked_inactive = $subtle
          
          # Groupbar (tab bar) styling
          groupbar {
              enabled = true
              font_family = JetBrainsMono Nerd Font
              font_size = 10
              gradients = false  # Disabled for cleaner look
              height = 16
              priority = 3
              render_titles = true
              scrolling = true
              
              # Tab colors - subtle palette
              col.active = $highlightHigh
              col.inactive = $highlightLow
              col.locked_active = $highlightMed
              col.locked_inactive = $overlay
              
              # Text colors
              text_color = $text
          }
      }
      #############
      ### INPUT ###
      #############

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input {
          kb_layout = umlauteKeymap # this is configured in linux/default.nix

          follow_mouse = 0

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

          touchpad {
              natural_scroll = true
          }
      }

      gesture = 3, horizontal, workspace


      ####################
      ### KEYBINDINGSS ###
      ####################


      # See https://wiki.hyprland.org/Configuring/Keywords/
      $mainMod = ALT

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      #bind = CTRL, SPACE, exec, $terminal
      bind = SUPER, Q, killactive,
      bind = SUPER, SPACE, exec, $menu
      bind = SUPER SHIFT, SPACE, exec, $powermenu
      bind = $mainMod, J, togglesplit, # dwindle
      bind = SUPER, T, togglefloating
      bind = $mainMod SHIFT, W, exec, pkill -USR1 waybar


      bind = $mainMod, h ,movefocus, l
      bind = $mainMod, l, movefocus, r
      bind = $mainMod, k, movefocus, u
      bind = $mainMod, j, movefocus, d

      # Resize window
      bind = SUPER $mainMod, h, resizeactive, -160 0
      bind = SUPER $mainMod, l, resizeactive, 160 0
      bind = SUPER $mainMod, k, resizeactive, 0 -160
      bind = SUPER $mainMod, j, resizeactive, 0 160
      # Switch workspaces with mainMod + [0-9]
      bind = ALT, 1, workspace, 1
      bind = ALT, 2, workspace, 2
      bind = ALT, 3, workspace, 3
      bind = ALT, 4, workspace, 4
      bind = ALT, 5, workspace, 5
      bind = ALT, 6, workspace, 6
      bind = ALT, 7, workspace, 7
      bind = ALT, 8, workspace, 8
      bind = ALT, 9, workspace, 9
      bind = ALT, 0, workspace, 10

      # move i window on screen
      bind = $mainMod SHIFT, H, movewindow, l
      bind = $mainMod SHIFT, L, movewindow, r
      bind = $mainMod SHIFT, K, movewindow, u
      bind = $mainMod SHIFT, J, movewindow, d

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = ALT SHIFT, 1, movetoworkspacesilent, 1 
      bind = ALT SHIFT, 2, movetoworkspacesilent , 2
      bind = ALT SHIFT, 3, movetoworkspacesilent, 3
      bind = ALT SHIFT, 4, movetoworkspacesilent, 4
      bind = ALT SHIFT, 5, movetoworkspacesilent, 5
      bind = ALT SHIFT, 6, movetoworkspacesilent, 6
      bind = ALT SHIFT, 7, movetoworkspacesilent, 7
      bind = ALT SHIFT, 8, movetoworkspacesilent, 8
      bind = ALT SHIFT, 9, movetoworkspacesilent, 9
      bind = ALT SHIFT, 0, movetoworkspacesilent, 10

      # Toggle group mode
      bind = SUPER SHIFT, G, togglegroup  # Remove comma after SUPER

      # Cycle
      bind = SUPER, C, changegroupactive, f  
      bind = SUPER SHIFT, C, changegroupactive, b  

      # Remove window from group
      bind = SUPER SHIFT, R, moveoutofgroup

      # Lock/unlock group (prevent accidental changes)
      bind = SUPER SHIFT, L, lockgroups, toggle  # Remove comma after SUPER

      # Add to group (directional)
      bind = SUPER SHIFT, H, moveintogroup, l  # Add to group on left
      bind = SUPER SHIFT, L, moveintogroup, r  # Add to group on right

      binds {
          drag_threshold = 10  # Fire a drag event only after dragging for more than 10px
      }
      bindm = ALT, mouse:272, movewindow      # ALT + LMB: Move a window by dragging more than 10px.

      # fullscreen
      bind = SUPER, F, fullscreen

      # hyprlock
      bind = SUPER, l, exec, hyprlock

      # screenshot to clipboard
      bind = SUPER, s, exec,  hyprshot -m region --clipboard-only

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################

      workspace = 1, persistent:true
      workspace = 2, persistent:true
      workspace = 3, persistent:true

      # Fix some dragging issues with XWayland
      windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
      windowrulev2 = suppressevent maximize, class:.* # You'll probably like this.
      windowrulev2 = float, class:^MainView$
      windowrulev2 = focusonactivate, class:.*
      # fix jetbrains
      windowrulev2 = noinitialfocus,class:(jetbrains-)(.*),title:^win(.*), initialTitle:win.*, floating:1  

      windowrulev2 = maximize, class:^(Emacs)$, workspace:1
      windowrulev2 = maximize, class:^(com.mitchellh.ghostty)$, workspace:3    '';
  };
}
