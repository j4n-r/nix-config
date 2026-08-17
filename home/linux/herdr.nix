{ ... }:

{
  xdg.configFile."herdr/config.toml".text = ''
    # Managed by home-manager.
    onboarding = false

    [theme]
    name = "rose-pine"

    [terminal]
    default_shell = "fish"
    shell_mode = "login"
    new_cwd = "follow"

    [keys]
    # Direct tab/workspace navigation; prefix bindings remain available too.
    switch_tab = ["prefix+1..9", "ctrl+alt+1..9"]
    switch_workspace = ["prefix+shift+1..9", "ctrl+alt+shift+1..9"]
    previous_tab = ["prefix+p", "ctrl+alt+["]
    next_tab = ["prefix+n", "ctrl+alt+]"]

    [update]
    channel = "stable"
    version_check = true
    manifest_check = true
  '';
}
