{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = true; # Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "zap";
    };

    brews = [
      "pbcopy"
    ];

    casks = [
      "1password-cli"
      "karabiner-elements"
      "raycast"
      "ghostty"
      "spotify"
      "google-chrome"
      "slack"
      "amethyst"
      "tuple"
    ];

  };

}
