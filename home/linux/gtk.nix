{ pkgs, ... }:
{

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.theme = null;
    theme = {
      name = "rose-pine";
      # The theme's "dark variant" (gtk-dark.css) is a light palette, and both
      # gtk-application-prefer-dark-theme and Chromium/Electron (which follow
      # the portal's prefer-dark) load it, turning those apps light. Make the
      # dark variant the regular dark theme.
      package = pkgs.rose-pine-gtk-theme.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          for d in $out/share/themes/rose-pine/gtk-3.0 $out/share/themes/rose-pine/gtk-3.20; do
            chmod u+w $d/gtk-dark.css
            cp $d/gtk.css $d/gtk-dark.css
          done
        '';
      });
    };
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
  };
}
