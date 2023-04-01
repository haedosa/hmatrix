{ mkDerivation, array, base, binary, bytestring, deepseq
, finite-typelits, lib, mtl, blas, lapack, primitive, random
, semigroups, split, storable-complex, vector
}:
mkDerivation {
  pname = "hmatrix";
  version = "0.20.2";
  sha256 = "05462prqkbqpxfbzsgsp8waf0sirg2qz6lzsk7r1ll752n7gqkbg";
  configureFlags = [ "-fdisable-default-paths"  ];
  libraryHaskellDepends = [
    array base binary bytestring deepseq finite-typelits mtl primitive
    random semigroups split storable-complex vector
  ];
  librarySystemDepends = [ blas lapack ];
  homepage = "https://github.com/haskell-numerics/hmatrix";
  description = "Numeric Linear Algebra";
  license = lib.licenses.bsd3;
}
