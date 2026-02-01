{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
  opencode_dev = inputs."opencode-dev";
in
{
  environment.systemPackages = [
    opencode_dev.packages.${pkgs.system}.default
    unstable.codex
    unstable.tsx

    unstable.gemini-cli-bin
    unstable.codex

    # unstable.zed-editor
    # unstable.jetbrains.clion
    #unstable.jetbrains.rust-rover

    unstable.protonmail-desktop
    unstable.protonvpn-gui

    unstable.zls
  ];
}
