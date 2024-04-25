{
  description = "Flake that provides preconfigured IDEs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    , neovim-nightly-overlay
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ neovim-nightly-overlay.overlay ];
      };
      lib = pkgs.lib;
      nv = import ./neovim {
        inherit nixvim pkgs lib system;
      };
    in
    {
      nvim = {
        standalone = cfg: nv.standalone cfg;
        homeManagerModules.nvim = cfg: (nv.homevim cfg);
      };
      devShells.default = pkgs.mkShell {
        buildInputs = [
          (self.nvim.${system}.standalone { })
        ];
      };
    });
}
