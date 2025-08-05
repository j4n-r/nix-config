{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zed-editor
    doppler
    wireshark
    coreutils-prefixed
    packer
    jetbrains.pycharm-professional
    gemini-cli
  ];
}
