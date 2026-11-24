{
  # Hetzner Cloud ARM (CAX) servers boot via UEFI from a single virtio-scsi disk.
  disko.devices.disk.system = {
    type = "disk";
    device = "/dev/sda";

    content = {
      type = "gpt";

      partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        swap = {
          size = "4G";
          content = {
            type = "swap";
          };
        };

        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
