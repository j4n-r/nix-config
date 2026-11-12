{
  pkgs,
  inputs,
  config,
  ...
}:

let
  hex = "${config.programs.hex.package}/bin/hex";
in
{
  imports = [ inputs.hex.homeManagerModules.default ];

  programs.hex = {
    enable = true;
    autostart = true;
    # English-only, and faster than the multilingual cohere_transcribe.
    model = "parakeet_unified_en";
    # Ghostty pastes only on Ctrl+Shift+V; a plain Ctrl+V reaches TUIs like Amp as a raw key.
    settings.paste_with_shift = true;
  };
  # Hex fallback: when it records from the default input and that is
  # Bluetooth, it moves its capture to a wired mic with pactl; without it,
  # Hex records from the AirPods and pins them to the low-quality HFP profile.
  home.packages = [ pkgs.pulseaudio ];

  # Use compositor-owned shortcuts without the GlobalShortcuts portal.
  # Not Alt+Space: Niri swallows Space, so the focused app sees a lone Alt tap,
  # which focuses Electron menu bars (Amp desktop) and catches Hex's paste.
  # Not Ctrl+Space either: Neovim uses it for completion.
  programs.niri.settings.binds = {
    "Ctrl+Shift+Space" = {
      repeat = false;
      hotkey-overlay.title = "Hold to dictate with Hex";
      press.spawn = [
        hex
        "dictation"
        "start"
      ];
      release.spawn = [
        hex
        "dictation"
        "stop"
      ];
    };
    "Ctrl+Alt+V" = {
      repeat = false;
      hotkey-overlay.title = "Paste last Hex dictation";
      action.spawn = [
        hex
        "paste-last"
      ];
    };
  };
}
