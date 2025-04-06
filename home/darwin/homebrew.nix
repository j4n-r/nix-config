{ config, pkgs, ... }:

{
homebrew = {
    enable = true;

    casks = [
      "1password-cli"
      "karabiner-elements"
      "raycast"
      "ghostty"
      "spotify"
      "google-chrome"
      "slack"
      "amethyst"
    ];

  };

}
