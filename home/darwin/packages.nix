{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zed-editor
    doppler
    wireshark
    yaak
    packer
  ];
}
