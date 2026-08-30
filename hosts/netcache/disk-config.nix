{
  disko.devices.disk = {
    system = {
      type = "disk";
      device = "/dev/vda";

      content = {
        type = "gpt";

        partitions = {
          bios-boot = {
            size = "1M";
            type = "EF02";
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

    nix-store = {
      type = "disk";
      device = "/dev/vdb";

      content = {
        type = "gpt";

        partitions.nix = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/nix";
            mountOptions = [ "noatime" ];
          };
        };
      };
    };
  };
}
