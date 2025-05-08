# Nix Config

Some Linux Desktop stuff expects this directory to be `~/nix-config`

## Nix Darwin 
To rebuild on a new MacOS system navigate into the `nix-config` dir and run 
```
nix run nix-darwin/master#darwin-rebuild -- switch --flake .
```

after the initial install the normal command will work
```
darwin-rebuild switch --flake ~/nix-config/ --show-trace
```

## Overview
```
.
├── color-schemes
│   └── rose-pine.yaml
├── flake.lock
├── flake.nix
├── home
│   ├── base
│   │   ├── btop.nix
│   │   ├── default.nix
│   │   ├── direnv.nix
│   │   ├── fish.nix
│   │   ├── fonts.nix
│   │   ├── ghostty.nix
│   │   ├── ssh.nix
│   │   ├── starship.nix
│   │   └── zathura.nix
│   ├── darwin
│   │   ├── amethyst.nix
│   │   ├── default.nix
│   │   ├── karabiner.nix
│   │   └── packages.nix
│   └── linux
│       ├── chromium.nix
│       ├── default.nix
│       ├── dunst.nix
│       ├── gtk.nix
│       ├── hypr
│       │   ├── hypridle.nix
│       │   ├── hyprland.nix
│       │   └── hyprlock.nix
│       ├── rofi
│       │   ├── rofi.nix
│       │   └── rofiTheme
│       └── waybar
│           ├── modules
│           │   └── spotify.sh
│           ├── rose-pine.css
│           ├── style.css
│           └── waybar.nix
├── hosts
│   ├── j4n-r-hmb
│   │   ├── default.nix
│   │   ├── hardware-configuration.nix
│   │   └── home.nix
│   ├── j4n-r-tp6
│   │   ├── default.nix
│   │   ├── hardware-configuration.nix
│   │   └── home.nix
│   └── MacBook-Air-100011
│       ├── home.nix
│       └── user-hosts.nix
├── modules
│   ├── base.nix
│   ├── darwin
│   │   ├── base.nix
│   │   ├── homebrew.nix
│   │   └── system.nix
│   ├── dev.nix
│   └── nixos
│       ├── base.nix
│       └── desktop.nix
├── README.md
├── scripts
│   └── linux
│       ├── now-playing
│       ├── play-next
│       ├── play-previous
│       └── powermenu.sh
├── shells
│   └── emacs-libvterm.nix
└── wallpapers
    ├── abstract.jpeg
    ├── bay.jpg
    ├── clouds.jpg
    └── moon.jpg

21 directories, 54 files

```
