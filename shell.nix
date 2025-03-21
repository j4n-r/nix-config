# shell to compile emacs vterm
with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "emacsenv";
  nativeBuildInputs = [ cmake enchant pkg-config];
  buildInputs = [ libvterm-neovim enchant];
} 
