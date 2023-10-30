{
  description = "Flake that provides preconfigured IDEs";

  inputs = {
    nixpkgs.url = "nixpkgs";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    { self
    , nixvim
    , flake-utils
    , nixpkgs
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      nvim = import ./neovim { inherit nixpkgs nixvim system; };
      buildInputs = with pkgs; [
        nvim
      ];
    in
    {
      devShells.default = pkgs.mkShell {
        inherit buildInputs;
        shellHook = ''
        '';
      };
    });
}
