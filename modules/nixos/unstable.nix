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
    unstable.codex
    unstable.tsx

    unstable.gemini-cli-bin
    unstable.codex

    unstable.zed-editor
    # unstable.jetbrains.clion
    #unstable.jetbrains.rust-rover

    unstable.protonmail-desktop
    unstable.protonvpn-gui

    unstable.zls
  ];
}
