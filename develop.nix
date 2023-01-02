{ pkgs }: with pkgs; let

  ghcid-bin = haskellPackages.ghcid.bin;

  ghcid-bin-with-openblas = let
    ghcid = "${ghcid-bin}/bin/ghcid";
    out = "$out/bin/ghcid";
  in runCommand "ghcid" { buildInputs = [ makeWrapper ]; } ''
    makeWrapper ${ghcid} ${out} --add-flags \
      "--command='cd packages/base && \
                    cabal repl lib:hmatrix \
                    --flags=openblas \
                    --extra-lib-dirs=${openblasCompat}/lib \
                    --extra-include-dir=${openblasCompat}/include \
                 '"
  '';

  ghcid-gsl = let
    ghcid = "${ghcid-bin}/bin/ghcid";
    out = "$out/bin/ghcid";
  in runCommand "ghcid" { buildInputs = [ makeWrapper ]; } ''
    makeWrapper ${ghcid} ${out} --add-flags \
      "--command='cd packages/gsl && \
                    cabal repl lib:hmatrix-gsl \
                    --flags=openblas \
                    --extra-lib-dirs=${openblasCompat}/lib \
                    --extra-include-dir=${openblasCompat}/include \
                 '"
  '';

in haskellPackages.shellFor {
  withHoogle = true;
  packages = p: with p; [
    hmatrix
    hmatrix-glpk
    hmatrix-gsl
    # hmatrix-sparse # requires mkl
    hmatrix-special
    hmatrix-tests
  ];
  buildInputs =
    (with haskellPackages;
    [ haskell-language-server
      ghcid
    ]) ++
    [ ghcid-bin
      ghcid-bin-with-openblas
      ghcid-gsl
      cabal-install
    ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [ openblasCompat ];
}
