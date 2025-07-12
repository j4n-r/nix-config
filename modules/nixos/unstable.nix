{ pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable { system = pkgs.system; };
in
{
  environment.systemPackages = [ unstable.opencode ];
}
