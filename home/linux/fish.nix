{pkgs, ...}:

{
  programs.fish = {
    enable =true;
  # use bash as login shell the switch to fish

  interactiveShellInit = ''
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

if [ (tty) = "/dev/tty1" ]
    exec Hyprland
end

if test (tty) = "/dev/tty1"
    exec Hyprland
end
'';
  };
}
