{pkgs, config,  ...}:

{
  home.packages = with pkgs; [
   home-manager
   btop
   git
   cmake
   emacs
   chromium
   curl
   ghostty
   wget 
   neovim  
  ];
}
