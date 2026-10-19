{ pkgs, ... }:

{
  home.packages = with pkgs; [
    doppler
    wireshark
    coreutils-prefixed
    packer
    jetbrains.pycharm-professional
    gemini-cli
  ];
}
