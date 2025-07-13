{ inputs, ... }:
{
  imports = [
    inputs.sherlock.homeManagerModules.default
  ];

  programs.sherlock = {
    enable = true;
    settings = {
      config = {
        appearance = {
          width = 800;
          height = 450;
        };
        daemonize = true;
        debug = {
          try_suppress_warnings = true;
        };
        binds.modifier = "control";
      };
      ignore = ''
        Avahi*
      '';
      launchers = [
        {
          name = "App Launcher";
          type = "app_launcher";
          args = { };
          priority = 1;
          home = true;
        }
      ];
      style = ''
        :root {
            --background: 247, 23%, 15%;
            --foreground: 249, 15%, 28%;
            --text: 245, 50%, 91%;
            --border: 248, 21%, 26%;
      '';
    };
  };
}
