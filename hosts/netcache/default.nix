{
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  networking = {
    hostName = "netcache";

  };

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
  };

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
      restartUnits = [ "harmonia.s" ];
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
    "@wheel"
  ];

  # Accept locally built, unsigned paths uploaded over SSH.
  nix.settings.require-sigs = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";
}
