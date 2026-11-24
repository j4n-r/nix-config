# Nix Config

Some Linux Desktop stuff expects this directory to be `~/nix-config`

## Secrets (sops-nix)

Encrypted with [sops](https://github.com/getsops/sops) + age, committed to this repo,
decrypted on the target host. Editor key: personal age key in
`~/.config/sops/age/keys.txt` (laptop only, backed up in Bitwarden). Host keys are derived
automatically from `/etc/ssh/ssh_host_ed25519_key`. Public `age1...` keys live in
`.sops.yaml`:

```yaml
keys:
  - &jan age1... # personal
  - &netcache age1... # host
creation_rules: # first match wins; per-host regex so hosts can't read each other
  - path_regex: hosts/netcache/secrets\.yaml$
    key_groups:
      - age: [*jan, *netcache]
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

### Deploy (deploy-rs)

deploy-rs is defined in `flake.nix` (`deploy.nodes.netcache`) and runs from the laptop:

```bash
deploy .#netcache    # deploy-rs is in the devShell (modules/dev.nix): nix develop -c deploy .#netcache
```

```nix
deploy.nodes.netcache = {
  hostname = "netcache";
  sshUser = "root";               # SSH connection user (overrides ~/.ssh/config's User)
  profiles.system = {
    user = "root";                # profile owner on the target, activation runs as this
    path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.netcache;
  };
};
```

Notes:

- deploy-rs always connects as `<sshUser>@<hostname>` explicitly, so it **ignores
  `~/.ssh/config`'s `User`** — `sshUser` must be set in the flake (without it, it falls
  back to your _local_ username and the deploy fails).
- If `sshUser` differs from the profile `user`, deploy-rs activates via `sudo -u <user>`;
  since both are `root` here, no sudo is involved.
- deploy-rs activates atomically and auto-rolls back on boot failure (magic rollback).
- `checks` in `flake.nix` runs `deployChecks`, so `nix flake check` also verifies all
  deploy targets.

### Deploy (nixos-rebuild alternative)

From the laptop (builds locally, uploads the closure, decrypts on the target):

```bash
nixos-rebuild switch --flake .#netcache --target-host netcache --use-remote-sudo
```

`netcache` resolves via `~/.ssh/config`. Do **not** run this under `sudo` — root has no
access to your SSH keys. Let the _target_ elevate with `--use-remote-sudo` instead.

### Push to the cache

Build all host closures, upload, sign remotely (signing key never leaves the box):

```fish
for host in  j4n-r-tp6
  set out (nix build --print-out-paths ".#nixosConfigurations.$host.config.system.build.toplevel")
  nix copy --to ssh://netcache "$out"
  ssh root@netcache "nix store sign --key-file /run/secrets/harmonia -r $out"
end
```

Clients need netcache as substituter + its public key
(`ssh root@netcache 'nix key convert-secret-to-public < /run/secrets/harmonia'`):

```nix
nix.settings = {
  substituters = [ "http://152.53.17.131:5000" ];
  trusted-public-keys = [ "<cachename>:<base64pubkey>" ];
};
```

## Hetzner (NixOS VPS, Hetzner Cloud ARM)

Replaces the Coolify server at `91.99.52.144` (`aarch64-linux`). Runs Stirling PDF behind
Caddy (`pdf.j4n.me`), Grafana Alloy, and Tailscale. Config in `hosts/hetzner/`. The laptop
cannot build `aarch64` closures, so installs and deploys build on the server.

### Install (wipes the disk)

Pre-generate the SSH host key so its age key can encrypt the secrets before the install:

```bash
mkdir -p /tmp/hetzner-root/etc/ssh
ssh-keygen -t ed25519 -N "" -C root@hetzner -f /tmp/hetzner-root/etc/ssh/ssh_host_ed25519_key
nix run nixpkgs#ssh-to-age -- < /tmp/hetzner-root/etc/ssh/ssh_host_ed25519_key.pub
# add the age key and a hosts/hetzner/secrets\.yaml$ rule to .sops.yaml, then:
EDITOR=nvim sops hosts/hetzner/secrets.yaml   # alloy.env, same keys as netcache
git add hosts/hetzner/secrets.yaml .sops.yaml
nix run github:nix-community/nixos-anywhere -- --flake .#hetzner --build-on remote \
  --extra-files /tmp/hetzner-root root@91.99.52.144
ssh hetzner tailscale up
```

### Deploy

Deploys are automatic. A push to `main` runs `.github/workflows/deploy.yml`, which builds the
hetzner system on an arm64 runner and fast-forwards the `deploy` branch. comin on the server
(`hosts/hetzner/deploy.nix`) polls `deploy` every 60 s, builds, and switches. A Tulsi push
that passes its CI pins itself in `flake.lock` here (Tulsi's `deploy.yml`), which starts the
same pipeline. comin's metrics go to Grafana (`job="comin"`).

Keys: a read-only deploy key on `j4n-r/tulsi` (SOPS `tulsi-deploy-key` for the server,
`TULSI_DEPLOY_KEY` secret in both repos for CI) and a write deploy key on this repo
(`NIX_CONFIG_DEPLOY_KEY` in Tulsi) for the pin commit.

Manual deploy, such as the first one that installs comin:

```bash
deploy .#hetzner   # remoteBuild: the server builds its own closure
```

### Tulsi first deployment

Tulsi runs on `127.0.0.1:8081`, separate from Stirling PDF. Set a **proxied** Cloudflare A record for `tulsi.j4n.me` and use **Full (strict)** TLS. Caddy rejects direct requests to the Tulsi vhost and passes the client address from Cloudflare to Tulsi. Confirm that origin certificate issuance works and that direct HTTPS requests to the origin are rejected before relying on the site. Keep the [Cloudflare source ranges](https://www.cloudflare.com/ips/) in `hosts/hetzner/tulsi.nix` current.

Publish the Tulsi revision that includes its NixOS module and `init-admin` before running `nix flake update tulsi`. Keep Tulsi's own nixpkgs pin; the host's stable Go is too old. The remote builder must be able to fetch the private Tulsi input. For local evaluation before publication, pass `--override-input tulsi git+file:///home/j4n-r/dev/tulsi --no-write-lock-file`.

Edit `hosts/hetzner/secrets.yaml` with SOPS. Add two multiline dotenv values and extend the existing Alloy dotenv value:

- `tulsi.env`: `SECRET_KEY` (32 random bytes, base64), `YOUTUBE_API_KEY`, and `BASE_URL`, `MODEL`, and `API_KEY` for each of the prefixes `AI`, `AI_DECISION`, `AI_IMAGE`, `AI_VISION`, and `AI_VIDEO` (for example, `AI_BASE_URL`). Keep the same `SECRET_KEY` on restore so Tulsi can read the AI keys stored in SQLite.
- `tulsi-litestream.env`: `LITESTREAM_BUCKET`, `LITESTREAM_ENDPOINT` (for example `https://fsn1.your-objectstorage.com`), `LITESTREAM_REGION` (for example `fsn1`), `AWS_ACCESS_KEY_ID`, and `AWS_SECRET_ACCESS_KEY`. Use credentials dedicated to this backup and a fresh `tulsi/hetzner` prefix.
- `alloy.env`: add `TULSI_OTLP_ENDPOINT` (Grafana Cloud OTLP gateway base URL, including `/otlp`), `TULSI_OTLP_USERNAME`, and `TULSI_OTLP_API_KEY` (token with `metrics:write` and `traces:write`). Alloy receives Tulsi metrics and traces on loopback; Tulsi logs still go through the journal to Loki.

For an intentionally fresh first deployment only, set `TULSI_ALLOW_EMPTY_DB=1` in `tulsi-litestream.env`. Without it, an absent database and missing replica block startup rather than silently starting empty. Build the native ARM64 closure before activation, then check `tulsi.service`, `tulsi-restore.service`, `tulsi-litestream.service`, and `alloy.service`. Run `sudo tulsi-init-admin jan` and confirm login.

Once Litestream has replicated, restore into a **separate** file and check `PRAGMA integrity_check;` and that the test account is present. Use the Litestream executable and config shown by `systemctl cat tulsi-litestream` with the same `EnvironmentFile`, but run `restore -config CONFIG -o NEW_FILE /var/lib/tulsi/tulsi.db`. Test against the actual bucket and remove `TULSI_ALLOW_EMPTY_DB=1` before adding real data. On disaster recovery, confirm the restored data instead of initializing a new admin. NixOS rollback does not roll back SQLite.

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
│   ├── j4n-r-tp6
│   │   ├── default.nix
│   │   ├── hardware-configuration.nix
│   │   └── home.nix
│   └── netcache
│       ├── default.nix
│       ├── disk-config.nix
│       └── secrets.yaml        # encrypted (sops)
├── icons
│   └── ...
├── modules
│   ├── base.nix
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
