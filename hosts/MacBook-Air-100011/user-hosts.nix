{ hostname, username,pkgs, ... }: #initialized in flake.nix

#############################################################
#
#  Host & Users configuration
#
#############################################################

{
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

    users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
    uid = 502;
    shell = pkgs.fish;
    };
  users.knownUsers =  [username];

  nix.settings.trusted-users = [ username ];
}
