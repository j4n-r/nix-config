{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

  # Pi is a Bun executable, so unlike Node it does not already have libstdc++
  # loaded. rpiv-voice's sherpa-onnx and decibri addons need libstdc++ and ALSA
  # available at runtime on NixOS.
  piWithNativeLibs = pkgs.symlinkJoin {
    name = "pi-with-native-libs";
    paths = [ llmAgents.pi ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/pi \
        --prefix LD_LIBRARY_PATH : ${
          pkgs.lib.makeLibraryPath [
            pkgs.alsa-lib
            pkgs.stdenv.cc.cc.lib
          ]
        }
    '';
  };
in
{
  environment.systemPackages = [
    # opencode_dev.packages.${pkgs.stdenv.hostPlatform.system}.default
    unstable.bitwarden-desktop
    unstable.tsx
    unstable.protonmail-desktop
    unstable.proton-vpn
    unstable.zls
    unstable.opencode-desktop
    unstable.herdr
    
    unstable.cargo
    unstable.rustc
    unstable.rustfmt
    unstable.rust-analyzer
    unstable.clippy

  ]
  ++ (with llmAgents; [
    opencode2
    amp
    piWithNativeLibs
    chatgpt
    codex
    
    # ... other tools
  ]);
}
