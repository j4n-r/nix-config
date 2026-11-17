{ ... }:

{
  xdg.configFile."herdr/config.toml".text = ''
    # Managed by home-manager.
    onboarding = false

    [theme]
    name = "rose-pine"

    [terminal]
    default_shell = "nu"
    shell_mode = "login"
    new_cwd = "follow"

    [keys]
    # Direct tab/workspace navigation; prefix bindings remain available too.
    switch_tab = ["prefix+1..9", "ctrl+alt+1..9"]
    switch_workspace = ["prefix+shift+1..9", "ctrl+alt+shift+1..9"]
    previous_tab = ["prefix+p", "ctrl+alt+["]
    next_tab = ["prefix+n", "ctrl+alt+]"]
    # Cycle agents, or jump straight to agent 1-9 (sidebar order).
    next_agent = ["prefix+a", "ctrl+alt+a"]
    previous_agent = ["prefix+shift+a", "ctrl+alt+shift+a"]
    focus_agent = ["prefix+alt+1..9"]
    # prefix+minus is used for workspace 3 below.
    split_horizontal = "prefix+shift+v"
    # Swap the focused pane with its neighbour.
    swap_pane_left = "prefix+shift+h"
    swap_pane_right = "prefix+shift+l"

    # Jump to workspaces 1-5 with prefix + = / + / - / ^ / *.
    [[keys.command]]
    key = "prefix+="
    type = "shell"
    command = "\"$HERDR_BIN_PATH\" workspace focus 1"
    description = "switch to workspace 1"

    [[keys.command]]
    key = "prefix+shift+="
    type = "shell"
    command = "\"$HERDR_BIN_PATH\" workspace focus 2"
    description = "switch to workspace 2"

    [[keys.command]]
    key = "prefix+minus"
    type = "shell"
    command = "\"$HERDR_BIN_PATH\" workspace focus 3"
    description = "switch to workspace 3"

    [[keys.command]]
    key = "prefix+^"
    type = "shell"
    command = "\"$HERDR_BIN_PATH\" workspace focus 4"
    description = "switch to workspace 4"

    [[keys.command]]
    key = "prefix+*"
    type = "shell"
    command = "\"$HERDR_BIN_PATH\" workspace focus 5"
    description = "switch to workspace 5"

    [update]
    channel = "stable"
    version_check = true
    manifest_check = true
  '';
}
