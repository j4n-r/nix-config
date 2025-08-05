{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    brews = [
      "enchant"
      "libvterm"
      "sst/tap/opencode"
      "libiconv"

    ];

    taps = [
      "sst/tap"
    ];

    casks = [
      "claude-code"
      "virtualbox"
      "vagrant"
      "1password-cli"
      "yaak"
      "1password"
      "karabiner-elements"
      "raycast"
      "ghostty"
      "spotify"
      "google-chrome"
      "slack"
      "amethyst"
      "tuple"
      "orbstack"
    ];

  };

}
