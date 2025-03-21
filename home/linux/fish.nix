{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    # use bash as login shell the switch to fish

    interactiveShellInit = ''
            ####### vi bindings ########
            function fish_hybrid_key_bindings --description \
            "Vi-style bindings that inherit emacs-style bindings in all modes"
                for mode in default insert visual
                    fish_default_key_bindings -M $mode
                end
                fish_vi_key_bindings --no-erase
            end
            set -g fish_key_bindings fish_hybrid_key_bindings

            ####### emacs vterm shell ########
            function vterm_printf;
                if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end
                    # tell tmux to pass the escape sequences through
                    printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
                else if string match -q -- "screen*" "$TERM"
                    # GNU screen (screen, screen-256color, screen-256color-bce)
                    printf "\eP\e]%s\007\e\\" "$argv"
                else
                    printf "\e]%s\e\\" "$argv"
                end
          end


      ####### nix shell ########
      set -l nix_shell_info (
        if test -n "$IN_NIX_SHELL"
          echo -n "<nix-shell> "
        end
      )


      ####### start hyprland ########
            if [ (tty) = "/dev/tty1" ]
                exec Hyprland
            end

            if test (tty) = "/dev/tty1"
                exec Hyprland
            end
    '';
  };
}
