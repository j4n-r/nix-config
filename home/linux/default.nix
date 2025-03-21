{ pkgs, ...} :

{
  home.packages = with pkgs; [
    wofi 
    dunst 
    libnotify
  ];
}
