{ pkgs, ... }:
{
  nixpkgs.config = {
    permittedInsecurePackages = [
      "beekeeper-studio-5.1.5"
    ];
  };

  environment.systemPackages = with pkgs; [
    beekeeper-studio
  ];
}
