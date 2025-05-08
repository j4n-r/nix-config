# In your Home Manager configuration for the Linux host
# e.g., ~/nix-config/home/linux/default.nix (or a file imported by it)

{ pkgs, config, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform --ozone-platform=wayland"
      "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport,UseMultiPlaneFormatForHardwareVideo"
    ];
    # If you want to enable extensions through Home Manager (optional)
    # extensions = [
    #   { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin, for example
    # ];
  };
}
