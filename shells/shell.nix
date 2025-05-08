{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "emacsenv";
  buildInputs = [
    pkgs.cmake
    pkgs.enchant
    pkgs.pkg-config
    pkgs.libvterm-neovim
    pkgs.libvterm
  ];
}
