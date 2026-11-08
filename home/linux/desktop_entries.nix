{ pkgs, inputs, ... }:

let
  # Ships its own helium.desktop. For extra Chromium flags use
  # .override { commandLineArgs = "--enable-features=..."; }
  helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [ helium ];

  xdg.desktopEntries = {
    Neomacs = {
      name = "NEO Emacs";
      genericName = "Text Editor";
      exec = "/home/j4n-r/AppImages/neomacs-0.0.18-x86_64-unknown-linux-gnu.AppImage %F";
      icon = "${../../icons/neomacs.svg}";
      terminal = false;
      categories = [
        "Development"
        "TextEditor"
      ];
      mimeType = [ "text/plain" ];
    };
    Todoist = {
      name = "Todoist";
      genericName = "Task Manager";
      exec = "${pkgs.lib.getExe helium} --app=https://todoist.com/app";
      terminal = false;
      categories = [
        "Office"
        "ProjectManagement"
      ];
      icon = "todoist";
    };
    # Helium web apps. Helium's own shortcuts would point at a versioned store path.
    Amp = {
      name = "Amp";
      exec = "${pkgs.lib.getExe helium} --profile-directory=Default --app-id=bpgpkfmeagdpdcenbogglipmfkalmple";
      icon = "chrome-bpgpkfmeagdpdcenbogglipmfkalmple-Default";
      terminal = false;
      settings.StartupWMClass = "crx_bpgpkfmeagdpdcenbogglipmfkalmple";
    };
    ProtonDocs = {
      name = "Proton Docs";
      exec = "${pkgs.lib.getExe helium} --profile-directory=Default --app-id=pmijndpkpdodmjcnaoaocgnlempcpplp";
      icon = "chrome-pmijndpkpdodmjcnaoaocgnlempcpplp-Default";
      terminal = false;
      settings.StartupWMClass = "crx_pmijndpkpdodmjcnaoaocgnlempcpplp";
    };
    # en_GB so date properties show DD/MM/YYYY; Electron ignores LC_TIME
    obsidian = {
      name = "Obsidian";
      comment = "Knowledge base";
      exec = "env LANG=en_GB.UTF-8 obsidian %u";
      icon = "obsidian";
      terminal = false;
      categories = [ "Office" ];
      mimeType = [ "x-scheme-handler/obsidian" ];
      settings.StartupWMClass = "md.Obsidian";
    };
  };
}
