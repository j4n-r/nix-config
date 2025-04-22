# Nix Config

Some Linux Desktop stuff expects this directory to be `~/nix-config`

## Nix Darwin 
To rebuild on a new MacOS system navigate into the `nix-config` dir and run 
```
nix run nix-darwin/master#darwin-rebuild -- switch --flake .
```
