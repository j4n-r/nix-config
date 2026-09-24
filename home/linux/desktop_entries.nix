{ ... }:

{
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
    Helium = {
      name = "Helium";
      genericName = "Web Browser";
#       exec = "appimage-run /home/j4n-r/AppImages/helium.appimage --enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport,UseMultiPlaneFormatForHardwareVideo
# ";
      exec = "/home/j4n-r/AppImages/helium.appimage";
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
