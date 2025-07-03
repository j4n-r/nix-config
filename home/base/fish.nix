{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    # use bash as login shell the switch to fish

    interactiveShellInit = ''
        #### disable greeeting message ####
        set -g fish_greeting
        alias e="eza"
        alias ee="eza -la"


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


      # Only auto-start Zellij if NOT in Emacs vterm
      if status is-interactive; and not set -q ZELLIJ; and not [ (tty) = "/dev/tty1" ]
          if set -q INSIDE_EMACS; and string match -q "*vterm*" $INSIDE_EMACS
          else
              exec zellij
          end
      end

        if test (uname -m) = arm64
            /opt/homebrew/bin/brew shellenv | source
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
              direnv hook fish | source
    '';
  };
}
