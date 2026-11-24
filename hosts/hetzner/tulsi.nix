{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  tulsi = config.services.tulsi;
  dbPath = "${tulsi.dataDir}/tulsi.db";
  domain = "tulsi.j4n.me";
  litestream =
    lib.getExe
      inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.litestream;
  backupConfig = (pkgs.formats.yaml { }).generate "tulsi-litestream.yaml" {
    dbs = [
      {
        path = dbPath;
        replica = {
          type = "s3";
          bucket = "\${LITESTREAM_BUCKET}";
          path = "tulsi/hetzner";
          endpoint = "\${LITESTREAM_ENDPOINT}";
          region = "\${LITESTREAM_REGION}";
          force-path-style = true;
        };
      }
    ];
  };
  backupService = {
    inherit (tulsi) user group;
    environmentFile = config.sops.secrets."tulsi-litestream.env".path;
  };
  restore = pkgs.writeShellScript "tulsi-restore" ''
    args=(-if-db-not-exists)
    if [[ ''${TULSI_ALLOW_EMPTY_DB:-} == 1 ]]; then
      args+=(-if-replica-exists)
    fi
    exec ${litestream} restore -config ${backupConfig} "''${args[@]}" ${lib.escapeShellArg dbPath}
  '';
  # https://www.cloudflare.com/ips/ — applies only to Tulsi's ingress gate.
  cloudflare = lib.concatStringsSep " " [
    "173.245.48.0/20"
    "103.21.244.0/22"
    "103.22.200.0/22"
    "103.31.4.0/22"
    "141.101.64.0/18"
    "108.162.192.0/18"
    "190.93.240.0/20"
    "188.114.96.0/20"
    "197.234.240.0/22"
    "198.41.128.0/17"
    "162.158.0.0/15"
    "104.16.0.0/13"
    "104.24.0.0/14"
    "172.64.0.0/13"
    "131.0.72.0/22"
    "2400:cb00::/32"
    "2606:4700::/32"
    "2803:f800::/32"
    "2405:b500::/32"
    "2405:8100::/32"
    "2a06:98c0::/29"
    "2c0f:f248::/32"
  ];
in
{
  imports = [ inputs.tulsi.nixosModules.default ];

  sops.secrets = {
    "tulsi.env".restartUnits = [ "tulsi.service" ];
    "tulsi-litestream.env".restartUnits = [ "tulsi-litestream.service" ];
  };

  services.tulsi = {
    enable = true;
    port = 8081;
    environmentFile = config.sops.secrets."tulsi.env".path;
    environment = {
      OTEL_EXPORTER_OTLP_ENDPOINT = "http://127.0.0.1:4318";
      OTEL_SERVICE_NAME = "tulsi";
    };
  };

  services.caddy = {
    globalConfig = ''
      servers {
        trusted_proxies static ${cloudflare}
        client_ip_headers CF-Connecting-IP
      }
    '';
    virtualHosts.${domain}.extraConfig = ''
      @cloudflare remote_ip ${cloudflare}
      handle @cloudflare {
        reverse_proxy 127.0.0.1:${toString tulsi.port} {
          header_up X-Forwarded-For {client_ip}
        }
      }
      handle {
        respond 403
      }
    '';
  };

  systemd.services = {
    tulsi = {
      requires = [ "tulsi-restore.service" ];
      after = [ "tulsi-restore.service" ];
    };
    tulsi-restore = {
      description = "Restore Tulsi SQLite before starting Tulsi when the database is absent";
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "systemd-tmpfiles-setup.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        User = backupService.user;
        Group = backupService.group;
        EnvironmentFile = backupService.environmentFile;
        UMask = "0077";
        ExecStart = restore;
      };
    };
    tulsi-litestream = {
      description = "Replicate Tulsi SQLite to object storage";
      wantedBy = [ "multi-user.target" ];
      requires = [ "tulsi-restore.service" ];
      after = [
        "tulsi-restore.service"
        "tulsi.service"
      ];
      serviceConfig = {
        User = backupService.user;
        Group = backupService.group;
        EnvironmentFile = backupService.environmentFile;
        UMask = "0077";
        ExecStart = "${litestream} replicate -config ${backupConfig}";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };

  environment.etc."alloy/tulsi-otlp.alloy".source = ./tulsi-otlp.alloy;
  systemd.services.alloy.restartTriggers = [ config.environment.etc."alloy/tulsi-otlp.alloy".source ];
}
