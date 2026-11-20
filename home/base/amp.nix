{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Other modules, such as the private ones from nix-private, add to these settings.
  options.amp.settings = lib.mkOption {
    type = (pkgs.formats.json { }).type;
    default = { };
    description = "Contents of Amp's settings.json.";
  };

  config = {
    amp.settings = {
      "amp.terminal.detailsExpandedByDefault" = true;
      # amp comes from the Nix store; update it through the flake, not in place.
      "amp.runner.autoUpdate.enabled" = false;
      "amp.keymap" = {
        "prompt.clear" = "ctrl+shift+u";
        "thread.interrupt" = [ "esc esc" "ctrl+enter" ];
      };
      "amp.mcpTrustedServers" = [
        {
          serverName = "coolify";
          specHash = "332bcd485d9dfe7fc4cacb75906c7bba92899114fad8ac2d7f26d7f29b30e4c7";
          allow = true;
        }
        {
          serverName = "coolify";
          specHash = "dd96d46eddbba9bc758d25d82347339cead654452d56a207d18f3f6712b7e1c1";
          allow = true;
        }
      ];
    };

    # Managed declaratively; update settings here rather than through Amp.
    xdg.configFile."amp/settings.json".text = builtins.toJSON config.amp.settings;
  };
}
