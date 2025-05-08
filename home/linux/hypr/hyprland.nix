{ hyprlandMonitorConfig }:
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

      ###################
      ### MY PROGRAMS ###
      ###################

      # Set programs that you use
      $terminal = ghostty
      $fileManager = dolphin
      $menu = rofi -show drun

      #################
      ### AUTOSTART ###
      #################

      exec-once=hyprlock
      exec-once=waybar
      exec-once=emacs --daemon
      exec-once= nm-applet
      exec-once=blueman-applet
      exec-once= swaybg -o "*" -m "stretch" -i ~/nix-config/wallpapers/abstract.jpeg 
      exec-once = swaync
      exec-once=/usr/lib/polkit-kde-authentication-agent-1
      exec-once=hyprctl setcursor BreezeX-RosePineDawn-Linux 32
      exec-once = [workspace 1 silent] emacs
      exec-once = [workspace 2 silent] google-chrome-stable
      exec-once = [workspace 3 silent] ghostty
      exec-once = [workspace 4 silent] bitwarden
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
          #col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          # col.active_border = $rose $pine $love $iris 90deg 
          col.active_border = $iris
          #col.inactive_border = rgba(595959aa)
          col.inactive_border = $overlay

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = true

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false

          layout = dwindle
      }

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration {
          rounding = 10

          # Change transparency of focused and unfocused windows
          # active_opacity = 0.85
          # inactive_opacity = 0.75 

          # drop_shadow = true
          # shadow_range = 4
          # shadow_render_power = 3
          # col.shadow = rgba(1a1a1aee)

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur {
              enabled = true
              size = 3
              passes = 1
              
              vibrancy = 0.1696
          }
      }

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations {
          enabled = false

          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          # animation = windows, 1, 4, myBezier
          # animation = windowsOut, 1, 4, default, popin 80%
          # animation = border, 1, 10, default
          # animation = borderangle, 1, 4, default
          # animation = fade, 1, 4, default
          # animation = workspaces, 1, 4, default


          animation = windows, 1, 2, myBezier
          animation = windowsOut, 1, 2, default, popin 80%
          animation = border, 1, 4, default
          animation = borderangle, 1, 2, default
          animation = fade, 1, 2, default
          animation = workspaces, 1, 2, default
      }

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle {
          pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # You probably want this
      }

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      # master {
      #     new_is_master = true
      # }

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc { 
          force_default_wallpaper = 0 # Set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = true # If true disables the random hyprland logo / anime girl background. :(
          initial_workspace_tracking = 1
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

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures {
          workspace_swipe = true
          workspace_swipe_fingers = 3
      }


      ####################
      ### KEYBINDINGSS ###
      ####################


      # See https://wiki.hyprland.org/Configuring/Keywords/
      $mainMod = ALT

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      #bind = CTRL, SPACE, exec, $terminal
      bind = $mainMod, Q, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, $fileManager
      bind = $mainMod, V, togglefloating,
      bind = SUPER, SPACE, exec, $menu
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle

      # Move focus with mainMod + arrow keys
      bind = $mainMod, h , movefocus, l
      bind = $mainMod, l, movefocus, r
      bind = $mainMod, k, movefocus, u
      bind = $mainMod, j, movefocus, d

      # Resize window
      bind = SUPER ALT, h, resizeactive, -160 0
      bind = SUPER ALT, l, resizeactive, 160 0
      bind = SUPER ALT, k, resizeactive, 0 -160
      bind = SUPER ALT, j, resizeactive, 0 160
      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # move i window on screen
      bind = $mainMod SHIFT, H, movewindow, l
      bind = $mainMod SHIFT, L, movewindow, r
      bind = $mainMod SHIFT, K, movewindow, u
      bind = $mainMod SHIFT, J, movewindow, d

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1 
      bind = $mainMod SHIFT, 2, movetoworkspacesilent , 2
      bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
      bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
      bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
      bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
      bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
      bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
      bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
      bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10

      # Example special workspace (scratchpad)
      bind = $mainMod, S, togglespecialworkspace, magic
      bind = $mainMod SHIFT, S, movetoworkspace, special:magic

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # fullscreen
      bind = SUPER, F, fullscreen

      # hyprlock
      bind = SUPER, l, exec, hyprlock

      # Power menu 
      bind = SUPER, X, exec, ~/nix-config/scripts/linux/powermenu.sh

      # screenshot to clipboard
      bind = SUPER, s, exec, grim -g "$(slurp -d)" - | wl-copy
      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################


      # Example config for Zathura transparency
      windowrulev2 = opacity,0.8,class:^zathura$
      windowrulev2 = suppressevent maximize, class:.* # You'll probably like this.
      windowrulev2 = float, class:^MainView$
    '';
  };
}
