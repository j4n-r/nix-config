{
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./alloy.nix
  ];

  # Netcup stopped answering DHCP (2026-10-18), so addresses are static.
  networking = {
    hostName = "netcache";
    useDHCP = false;
    interfaces.ens3 = {
      ipv4.addresses = [
        {
          address = "152.53.17.131";
          prefixLength = 22;
        }
      ];
      ipv6.addresses = [
        {
          address = "2a0a:4cc0:1:178d::1";
          prefixLength = 64;
        }
      ];
    };
    defaultGateway = "152.53.16.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
    nameservers = [
      "1.1.1.1"
      "2606:4700:4700::1111"
    ];
  };

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
  };

  services.qemuGuest.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets."harmonia" = {
      restartUnits = [ "harmonia.service" ];
    };
    secrets."alloy.env" = {
      restartUnits = [ "alloy.service" ];
    };
  };

  services.harmonia.cache = {
    enable = true;
    signKeyPaths = [ "/run/secrets/harmonia" ];
  };

  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH62v4unWbspLD2wtIqdMo+r7fRNaPixCF9vXfk4Vyxa Netcup VPS (netcache)"
  ];

  nix.settings.trusted-users = [
    "root"
  ];

  # Accept locally built, unsigned paths uploaded over SSH.
  nix.settings.require-sigs = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";

}
