final: prev: with final; {

  haskell = let
    hlib = let oldLib = prev.haskell.lib; in oldLib // {
      configLLVM = drv: oldLib.appendConfigureFlag drv "--ghc-options=-fllvm";
      enableLLVM = drv: addLLVM (configLLVM drv);
      addLLVM = drv: llvm: drv.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ llvm ];
      });
      enableProf = drv: oldLib.enableExecutableProfiling (oldLib.enableLibraryProfiling drv);
      overridesOn = hlist: f: (hfinal: hprev: (__listToAttrs (map (name:
        { inherit name; value = f hprev."${name}";} )
        hlist)));
    };
    packageOverrides = lib.composeManyExtensions [
      (prev.haskell.packageOverrides or (_: _: {}))
      (hfinal: hprev: {
        threadscope = hlib.doJailbreak (hlib.markUnbroken (hprev.threadscope));
      })
      (prev.haskell.lib.packageSourceOverrides {
        hmatrix = ./packages/base;
        hmatrix-glpk = ./packages/glpk;
        hmatrix-gsl = ./packages/gsl;
        hmatrix-sparse = ./packages/sparse;
        hmatrix-special = ./packages/special;
        hmatrix-tests = ./packages/tests;
      })
      (hfinal: hprev: let
          blas = prev.blas.override {blasProvider = prev.mkl;};
          lapack = prev.lapack.override {lapackProvider = prev.mkl;};
        in {
          hmatrix = hprev.hmatrix.overrideAttrs (old: {
            buildInputs = [ blas lapack ];
            configureFlags = [ "-fdisable-default-paths" ];
          });
      })
    ];
  in prev.haskell // { lib = hlib; inherit packageOverrides; };

}
