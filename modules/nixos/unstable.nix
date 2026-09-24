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

  # opencode2's TUI (OpenTUI's libopentui.so) dlopens libwayland-client.so.0 at
  # runtime for clipboard access. NixOS does not have that soname on the default
  # loader path, so the native clipboard backend reports "unsupported" and Ctrl+V
  # silently pastes nothing (images included). pi gets away with it because it
  # shells out to wl-paste instead.
  opencode2WithWayland = pkgs.symlinkJoin {
    name = "opencode2-with-wayland";
    paths = [ llmAgents.opencode2 ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/opencode2 \
        --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath [ pkgs.wayland ]}
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
    unstable.typescript
    
    unstable.cargo
    unstable.rustc
    unstable.rustfmt
    unstable.rust-analyzer
    unstable.clippy

  ]
  ++ (with llmAgents; [
    opencode2WithWayland
    amp
    piWithNativeLibs
    chatgpt
    codex
    t3code-desktop
    
    # ... other tools
  ]);
}
