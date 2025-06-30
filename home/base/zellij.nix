{ ... }:
{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };

  # NOTE: the module only supports YAML config which is deprecated
  home.file.zellij = {
    target = ".config/zellij/config.kdl";
    text = ''
        simplified_ui false
        show_startup_tips false
        keybinds {
            unbind "Ctrl g" // unbind in all modes
            unbind "Ctrl h" // unbind in all modes
            normal {
                bind "Super y" { SwitchToMode "locked"; }
                bind "Super h" { SwitchToMode "move"; }
            }
            locked {
                bind "Super y" { SwitchToMode "normal"; }
            }
        }

        theme "rose-pine"

        themes {
          rose-pine {
              bg "#403d52"
              fg "#575279"
              red "#e0def4"
              green "#c4a7e7"
              blue "#9ccfd8"
              yellow "#f6c177"
              magenta "#c4a7e7"
              orange "#c4a7e7"
              cyan "#ebbcba"
              black "#26233a"
              white "#e0def4"
          }
      }
    '';
  };
}
