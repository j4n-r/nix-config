{
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./tulsi.nix
    ./deploy.nix
    ../../modules/nixos/alloy.nix
  ];

  # Hetzner Cloud answers DHCP for IPv4. IPv6 is left out: the public sites sit
  # behind the Cloudflare proxy, which reaches the origin over IPv4.
  networking.hostName = "hetzner";

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "usbhid"
    "sr_mod"
  ];

  # Installed as the removable EFI fallback, so booting does not depend on NVRAM entries.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
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
    secrets."alloy.env" = {
      restartUnits = [ "alloy.service" ];
    };
  };

  services.stirling-pdf = {
    enable = true;
    environment = {
      SERVER_ADDRESS = "127.0.0.1";
      SERVER_PORT = 8080;
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."pdf.j4n.me".extraConfig = ''
      reverse_proxy 127.0.0.1:8080
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII6xy5Wl65Vk7qvhTgXmxGRPqQb0wUUuyxL1ulcwAjoF Root Hetzner Coolify Server"
  ];

  nix.settings.trusted-users = [
    "root"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";
}
