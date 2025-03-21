{pkgs, ...}:

{
  programs.fish = {
    enable =true;
  # use bash as login shell the switch to fish

  interactiveShellInit = ''

if [ (tty) = "/dev/tty1" ]
    exec Hyprland
end

if test (tty) = "/dev/tty1"
    exec Hyprland
end
'';
  };
}
