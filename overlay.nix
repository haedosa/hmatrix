final: prev: with final; {

  haskellPackages = prev.haskellPackages.extend
    (haskell.lib.packageSourceOverrides {
      hmatrix = ./packages/base;
      hmatrix-glpk = ./packages/glpk;
      hmatrix-gsl = ./packages/gsl;
      hmatrix-sparse = ./packages/sparse;
      hmatrix-special = ./packages/special;
      hmatrix-tests = ./packages/tests;
    });

}
