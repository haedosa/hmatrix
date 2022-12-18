{
  description = "hmatrix";

  inputs = {

    haedosa.url = "github:haedosa/flakes";
    nixpkgs.follows = "haedosa/nixpkgs";
    flake-utils.follows = "haedosa/flake-utils";

  };

  outputs =
    inputs@{ self, nixpkgs, flake-utils, ... }:
    {
      overlay = nixpkgs.lib.composeManyExtensions (
                  [ (import ./overlay.nix)
                  ]);

    } // flake-utils.lib.eachDefaultSystem (system:

      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [ self.overlay ];
        };
      in rec {

        devShells.default = import ./develop.nix { inherit pkgs; };

        packages = {
          default = self.packages.${system}.hmatrix;
          hmatrix = pkgs.haskellPackages.hmatrix;
          hmatrix-glpk = pkgs.haskellPackages.hmatrix-glpk;
          hmatrix-gsl = pkgs.haskellPackages.hmatrix-gsl;
          hmatrix-sparse = pkgs.haskellPackages.hmatrix-sparse;
          hmatrix-special = pkgs.haskellPackages.hmatrix-special;
          hmatrix-tests = pkgs.haskellPackages.hmatrix-tests;
        };

      }
    );

}
