{...}:
{
  xdg.desktopEntries.org-protocol = {
    name = "org-protocol";
    exec = "emacsclient %u";
    terminal = false;
    categories = [ "System" ];
    mimeType = [ "x-scheme-handler/org-protocol" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/org-protocol" = [ "org-protocol.desktop" ];
    };
  };

}
