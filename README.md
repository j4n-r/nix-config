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

## Secrets (sops-nix)

Encrypted with [sops](https://github.com/getsops/sops) + age, committed to this repo,
decrypted on the target host. Editor key: personal age key in
`~/.config/sops/age/keys.txt` (laptop only, backed up in Bitwarden). Host keys are derived
automatically from `/etc/ssh/ssh_host_ed25519_key`. Public `age1...` keys live in
`.sops.yaml`:

```yaml
keys:
  - &jan age1...           # personal
  - &netcache age1...      # host
creation_rules:            # first match wins; per-host regex so hosts can't read each other
  - path_regex: hosts/netcache/secrets\.yaml$
    key_groups:
      - age: [ *jan, *netcache ]
```

### Editing secrets

```bash
EDITOR=nvim sops hosts/netcache/secrets.yaml
```

sops encrypts when the editor exits. **Top-level YAML key names = filenames on the host**
(`/run/secrets/<name>`) — keep them in sync with the config.

```nix
sops = {
  defaultSopsFile = ./secrets.yaml;   # required, sops-nix does not guess
  secrets."harmonia".restartUnits = [ "harmonia.service" ];
};
```

`restartUnits` restarts services holding the old value when the secret changes. Skip
`owner`/`mode` if the service uses systemd `LoadCredential` (harmonia does).

### Adding a new host

1. `ssh root@<host> 'cat /etc/ssh/ssh_host_ed25519_key.pub' | nix run nixpkgs#ssh-to-age --`
2. Add the `age1...` key + `creation_rules` entry (`path_regex: hosts/<host>/secrets\.yaml$`) to `.sops.yaml`
3. `EDITOR=nvim sops hosts/<host>/secrets.yaml`
4. Import `sops-nix.nixosModules.sops` in the host's module list in `flake.nix`

## Netcache (NixOS VPS, Netcup)

Binary cache server (Harmonia) + Tailscale. Config in `hosts/netcache/`, secrets in
`hosts/netcache/secrets.yaml` (encrypted, safe to commit).

### Deploy

From the laptop (builds locally, uploads the closure, decrypts on the target):

```bash
nixos-rebuild switch --flake .#netcache --target-host netcache --use-remote-sudo
```

`netcache` resolves via `~/.ssh/config`. Do **not** run this under `sudo` — root has no
access to your SSH keys. Let the *target* elevate with `--use-remote-sudo` instead.

### Verify

```bash
ssh root@netcache
ls -la /run/secrets/                 # secret present, root:root 0400
systemctl status harmonia.service    # socket-activated: inactive until first request is fine
curl -s http://localhost:5000/nix-cache-info
journalctl -u harmonia -n 20
```

### Troubleshooting

- `mac mismatch` / `no matching recipients` — encrypted file not encrypted for this host;
  check its age pub key in `.sops.yaml` against `ssh-to-age` of its host key
- `Failed at step CREDENTIALS` — name mismatch between the YAML key, `sops.secrets."<name>"`,
  and the consuming path (e.g. `signKeyPaths`); all three must be identical,
  `systemctl reset-failed harmonia.service` to recover
- `sops.defaultSopsFile has no value` — set `sops.defaultSopsFile = ./secrets.yaml;`

## Overview
```
.
├── color-schemes
│   └── rose-pine.yaml
├── flake.lock
├── flake.nix
├── home
│   ├── base
│   │   ├── btop.nix
│   │   ├── cmd.nix
│   │   ├── default.nix
│   │   ├── direnv.nix
│   │   ├── fish.nix
│   │   ├── fonts.nix
│   │   ├── ghostty.nix
│   │   ├── spell-check.nix
│   │   ├── ssh.nix
│   │   ├── starship.nix
│   │   ├── zathura.nix
│   │   └── zellij.nix
│   ├── darwin
│   │   ├── amethyst.nix
│   │   ├── default.nix
│   │   ├── karabiner.nix
│   │   └── packages.nix
│   └── linux
│       ├── chromium.nix
│       ├── default.nix
│       ├── desktop_entries.nix
│       ├── dunst.nix
│       ├── gtk.nix
│       ├── hypr
│       │   ├── hypridle.nix
│       │   ├── hyprland.nix
│       │   └── hyprlock.nix
│       ├── rofi
│       │   ├── rofi.nix
│       │   └── rofiTheme
│       └── waybar
│           ├── modules
│           │   └── spotify.sh
│           ├── rose-pine.css
│           ├── style.css
│           └── waybar.nix
├── hosts
│   ├── j4n-r-hmb
│   │   ├── default.nix
│   │   ├── hardware-configuration.nix
│   │   └── home.nix
│   ├── j4n-r-rpi5
│   │   ├── default.nix
│   │   └── home.nix
│   ├── j4n-r-tp6
│   │   ├── default.nix
│   │   ├── hardware-configuration.nix
│   │   └── home.nix
│   ├── MacBook-Air-100011
│   │   ├── home.nix
│   │   └── user-hosts.nix
│   └── netcache
│       ├── default.nix
│       ├── disk-config.nix
│       └── secrets.yaml        # encrypted (sops)
├── icons
│   └── ...
├── modules
│   ├── base.nix
│   ├── darwin
│   │   ├── base.nix
│   │   ├── homebrew.nix
│   │   └── system.nix
│   ├── dev.nix
│   └── nixos
│       ├── base.nix
│       ├── desktop.nix
│       ├── insecure.nix
│       └── unstable.nix
├── scripts
│   └── linux
│       └── ...
├── shells
│   └── ...
├── wallpapers
│   └── ...
└── .sops.yaml                  # sops creation rules (public keys only, safe to commit)
```
