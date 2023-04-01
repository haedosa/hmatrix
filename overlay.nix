final: prev: with final; {

  haskellPackages = prev.haskellPackages.extend (
    lib.composeManyExtensions [
      (haskell.lib.packageSourceOverrides {
        hmatrix = ./packages/base;
        hmatrix-glpk = ./packages/glpk;
        hmatrix-gsl = ./packages/gsl;
        hmatrix-sparse = ./packages/sparse;
        hmatrix-special = ./packages/special;
        hmatrix-tests = ./packages/tests;
      })
      (hfinal: hprev: {
        hmatrix = hfinal.callPackage ./packages/base {
          blas = prev.blas.override {blasProvider = prev.mkl;};
          lapack = prev.lapack.override {lapackProvider = prev.mkl;};
        };
      })
    ]);

}
