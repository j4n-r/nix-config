{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;

  };
in
{
  environment.systemPackages = [
    unstable.opencode
    unstable.tsx

    unstable.zed-editor
    # unstable.jetbrains.clion
    #unstable.jetbrains.rust-rover

    unstable.protonmail-desktop
    unstable.protonvpn-gui

    unstable.zls
  ];
}
