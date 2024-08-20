{...}: {
  imports = [./python];

  perSystem = {pkgs, ...}: {
    packages = {
      glc-player = pkgs.callPackage ./glc-player {
        inherit pkgs;
        inherit (pkgs.stdenv) mkDerivation;
      };

      collada2gltf = pkgs.callPackage ./collada2gltf {
        inherit pkgs;
        inherit (pkgs.stdenv) mkDerivation;
      };
    };
  };
}
