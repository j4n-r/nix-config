{ config, inputs, ... }:
# Pull-based deploys: comin polls the `deploy` branch, which CI fast-forwards
# to main after its checks pass (.github/workflows/deploy.yml), then builds
# and switches this host. CI also copies the built closure here, so comin
# usually finds it in the store. Grafana alerts on comin's failure metrics.
{
  imports = [ inputs.comin.nixosModules.comin ];

  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/j4n-r/nix-config.git";
        branches.main.name = "deploy";
        # comin would otherwise activate a `testing-hetzner` branch unbuilt by CI.
        branches.testing.name = "";
      }
    ];
    exporter.listen_address = "127.0.0.1";
  };

  # Evaluating the flake fetches the private Tulsi input over SSH as root.
  # A read-only deploy key on j4n-r/tulsi.
  sops.secrets.tulsi-deploy-key = { };
  programs.ssh = {
    knownHosts."github.com".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    extraConfig = ''
      Host github.com
        IdentityFile ${config.sops.secrets.tulsi-deploy-key.path}
        IdentitiesOnly yes
    '';
  };

  environment.etc."alloy/comin.alloy".text = ''
    prometheus.scrape "comin" {
      targets = [{
        __address__ = "127.0.0.1:${toString config.services.comin.exporter.port}",
        instance    = constants.hostname,
        job         = "comin",
      }]
      forward_to      = [prometheus.remote_write.metrics_service.receiver]
      scrape_interval = "60s"
    }
  '';
  systemd.services.alloy.restartTriggers = [ config.environment.etc."alloy/comin.alloy".text ];
}
