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
      "enchant"
      "libvterm"
    ];

    taps = [
      "d12frosted/emacs-plus"
    ];

    casks = [
      "emacs-plus"
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
