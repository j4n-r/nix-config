{ config, ... }:

{
  home.file.".pi/agent/keybindings.json".text = builtins.toJSON {
    # Emacs-style navigation for slash-command and other selectors.
    "tui.select.up" = "ctrl+p";
    "tui.select.down" = "ctrl+n";

    # Ctrl+P is otherwise globally bound to model cycling, which takes
    # precedence over the slash-command completion list.
    "app.model.cycleForward" = [ ];
  };
}
