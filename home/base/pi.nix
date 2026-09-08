{ config, ... }:

{
  # Pi extensions installed manually on this machine (documentation only):
  #   pi install npm:@plannotator/pi-extension
  #   pi install npm:pi-web-access
  #   pi install npm:@juicesharp/rpiv-voice
  #
  # Keep these as comments: extensions should not be installed automatically
  # on every system that imports this Home Manager module.

  home.file.".pi/agent/extensions/last-message-overlay.ts".source =
    ./pi-extensions/last-message-overlay.ts;

  home.file.".pi/agent/keybindings.json".text = builtins.toJSON {
    # Emacs-style navigation for slash-command and other selectors.
    "tui.select.up" = [
      "up"
      "ctrl+p"
    ];
    "tui.select.down" = [
      "down"
      "ctrl+n"
    ];
    "tui.editor.deleteWordBackward" = [
      "alt+backspace"
    ];

    # Ctrl+P is otherwise globally bound to model cycling, which takes
    # precedence over the slash-command completion list.
    "app.model.cycleForward" = [ ];
  };
}
