{ nixvim
, pkgs
, system
, lib
, ...
}:
let
  defaultConfig = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
  };
in
{
  standalone = cfg: nixvim.legacyPackages."${system}".makeNixvim (lib.recursiveUpdate defaultConfig cfg);
  homecode = cfg:
    {
      programs.vscode = (lib.recursiveUpdate defaultConfig cfg);
    }
  ;
}
