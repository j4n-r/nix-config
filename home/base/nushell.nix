{ ... }:

# Nushell alongside fish (herdr and Ghostty open nu). Starship, zoxide and
# direnv hook into nu automatically through home.shell.enableNushellIntegration.
{
  programs.nushell = {
    enable = true;

    settings.show_banner = false;

    # Nu marks invalid input (such as an undefined $variable) as white on red,
    # which is unreadable with Rose Pine. Use red underlined text instead.
    # Set as a whole record: `settings` sets fields one by one and would keep
    # the default red background.
    extraConfig = ''
      $env.config.color_config.shape_garbage = { fg: red attr: u }
    '';

    # Mirrors the fish aliases. Plain `ls` stays nu's structured builtin.
    shellAliases = {
      cat = "bat";
      copy = "dms clipboard copy";
    };

    extraEnv = ''
      # Binaries installed with `go install`.
      $env.PATH = ($env.PATH | split row (char esep) | prepend ($env.HOME | path join "go" "bin") | uniq)
    '';
  };

  # Completions for external commands, which nu lacks out of the box.
  # Kept out of fish so fish keeps its own completions.
  programs.carapace = {
    enable = true;
    enableFishIntegration = false;
  };
}
