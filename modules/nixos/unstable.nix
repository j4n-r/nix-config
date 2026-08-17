{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  environment.systemPackages = [
    # opencode_dev.packages.${pkgs.stdenv.hostPlatform.system}.default
    unstable.tsx
    unstable.protonmail-desktop
    unstable.proton-vpn
    unstable.zls
    unstable.opencode-desktop
    unstable.herdr
  ]
  ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    opencode2
    gemini-cli
    # codex
    pi
    # ... other tools
  ]);
}
