{ ... }:

{
  sops.age.keyFile = "/home/j4n-r/.config/sops/age/keys.txt";

  sops.secrets."git-signing-key" = {
    sopsFile = ../../secrets/git-signing-key.yaml;
    mode = "0400";
    owner = "j4n-r";
  };
}
