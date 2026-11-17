{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    # use bash as login shell the switch to fish
    plugins = [
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
    ];

    shellInit = ''
      # Binaries installed with `go install`.
      fish_add_path -g $HOME/go/bin
    '';

    interactiveShellInit = ''
      # Use Emacs bindings consistently across hosts.
      fish_default_key_bindings

      #### disable greeeting message ####
      set -g fish_greeting
      alias cat="bat"
      alias copy="dms clipboard copy"



    '';
  };
}
