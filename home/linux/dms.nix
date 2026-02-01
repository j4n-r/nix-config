{
  pkgs,
  inputs,
  config,
  ...
}:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{

  home.packages = [
    pkgs.openhue-cli
  ];

  programs.dank-material-shell = {
    enable = true;
    dgop.package = unstable.dgop;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    settings = {
      monoFontFamily = "JetBrainsMono NF";
      soundsEnabled = false;
      acMonitorTimeout = 600;
      acLockTimeout = 300;

      currentThemeName = "dynamic";
      currentThemeCategory = "dynamic";
      dynamicTheming = true;
      customThemeFile = "/home/j4n-r/.config/DankMaterialShell/themes/rosePine/theme.json";
      registryThemeVariants = {
        rosePine = "rosePine";
      };
      matugenScheme = "scheme-tonal-spot";

      cursorSettings = {
        theme = "BreezeX-RosePineDawn-Linux";
        size = 27;
        niri = {
          hideWhenTyping = false;
          hideAfterInactiveMs = 0;
        };
        hyprland = {
          hideOnKeyPress = false;
          hideOnTouch = false;
          inactiveTimeout = 0;
        };
        dwl = {
          cursorHideTimeout = 0;
        };
      };

      barConfigs = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;
          position = 1;
          screenPreferences = [ "all" ];
          showOnLastDisplay = true;
          leftWidgets = [
            "workspaceSwitcher"
            "focusedWindow"
          ];
          centerWidgets = [
            "music"
            "weather"
            "clock"
          ];
          rightWidgets = [
            {
              id = "hueManager";
              enabled = true;
            }
            {
              id = "dockerManager";
              enabled = true;
            }
            {
              id = "cpuUsage";
              enabled = true;
            }
            {
              id = "memUsage";
              enabled = true;
            }
            {
            id = "diskUsage";
            enabled = true;
            mountPath = "/";
            }
            {
              id = "notificationButton";
              enabled = true;
            }
            {
              id = "battery";
              enabled = true;
            }
            {
              id = "controlCenterButton";
              enabled = true;
              showAudioPercent = true;
              showBrightnessIcon = true;
              showBrightnessPercent = false;
              showMicIcon = false;
              showBatteryIcon = true;
            }
            {
              id = "systemTray";
              enabled = true;
            }
          ];
          spacing = 4;
          innerPadding = 4;
          bottomGap = -12;
          transparency = 0;
          widgetTransparency = 0.3;
          squareCorners = false;
          noBackground = false;
          gothCornersEnabled = false;
          gothCornerRadiusOverride = false;
          gothCornerRadiusValue = 16;
          borderEnabled = false;
          borderColor = "secondary";
          borderOpacity = 1;
          borderThickness = 1;
          fontScale = 1.1;
          autoHide = false;
          autoHideDelay = 250;
          openOnOverview = false;
          visible = true;
          popupGapsAuto = true;
          popupGapsManual = 42;
          maximizeDetection = true;
          shadowOpacity = 10;
          shadowColorMode = "primary";
          shadowIntensity = 10;
          widgetOutlineEnabled = false;
        }
      ];
    };

    session = {
      isLightMode = false;
      weatherLocation = "Berlin";
      weatherCoordinates = "52.5173885,13.3951309";
      wallpaperPath = "/home/j4n-r/nix-config/wallpapers/abstract.jpeg";
    };

    clipboardSettings = {
      maxHistory = 25;
      maxEntrySize = 5242880;
      autoClearDays = 1;
      clearAtStartup = true;
      disabled = false;
      disableHistory = false;
      disablePersist = true;
    };

    managePluginSettings = true;
    plugins = {
      # Simply enable plugins by their ID (from the registry)
      dankBatteryAlerts.enable = true;
      dockerManager.enable = true;
      hueManager.enable = true;

      # Add plugin-specific settings
      mediaPlayer = {
        enable = true;

        # You can only define settings here if using the home-manager module
        settings = {
          preferredSource = "spotify";
        };
      };
    };

  };
}
