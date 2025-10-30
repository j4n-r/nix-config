{ ... }:

{
  xdg.desktopEntries = {
    Helium = {
      name = "Helium";
      genericName = "Web Browser";
      exec = "appimage-run /home/j4n-r/AppImages/helium.appimage";
      terminal = false;
      categories = [
        "Application"
        "Network"
        "WebBrowser"
      ];
      mimeType = [
        "text/html"
        "text/xml"
      ];
    };
    Todoist = {
      name = "Todoist";
      genericName = "Task Manager";
      exec = "appimage-run /home/j4n-r/AppImages/helium.appimage --app=https://todoist.com/app";
      terminal = false;
      categories = [
        "Office"
        "ProjectManagement"
      ];
      icon = "todoist";
    };
  };
}
