{...}: {
  imports = [./python];

  perSystem = {pkgs, ...}: {
    packages = {
      glc-player = pkgs.callPackage ./glc-player {
        inherit pkgs;
        inherit (pkgs.stdenv) mkDerivation;
      };
    };
  };
}
