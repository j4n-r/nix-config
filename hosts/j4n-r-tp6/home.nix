{config, pkgs,...}:

{
  home.username = "j4n-r";
  home.homeDirectory = "/home/j4n-r";
  
  programs.git = {
    enable = true;
    userName  = "j4n-r";
    userEmail = "jan.ruegge@gmail.com";
    extraConfig = {
      init = { defaultBranch = "main";};
      push = { autoSetupRemote = true; };
      core = { editor = "nvim";};
      color = { ui = true; };
      github = { user = "j4n-r";};
    };
  };
  imports = [
     ../../home/linux
     ../../home/base
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true; 
}
