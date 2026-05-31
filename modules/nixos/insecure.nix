{ pkgs, ... }:
{
  nixpkgs.config = {
    permittedInsecurePackages = [
      "beekeeper-studio-5.1.5"
      "electron-39.8.10"
    ];
  };

  environment.systemPackages = with pkgs; [
    beekeeper-studio
  ];
}
