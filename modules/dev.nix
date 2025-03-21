
{
  pkgs,
  ...
} : {
  environment.systemPackages = with pkgs; [
   btop
   emacs
   chromium

   # build tools
   cmake
   ninja
   cargo

   # languages
   nodejs
   python314

   # lsp & formatter 
   nil #nix lsp
   nixfmt-rfc-style 
  ];

}
