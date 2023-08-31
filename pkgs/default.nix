{...}: {
  imports = [./python];

  perSystem = {pkgs, ...}: {
    packages = {
      collada2gltf = pkgs.callPackage ./collada2gltf {
        inherit pkgs;
        inherit (pkgs.stdenv) mkDerivation;
      };

      openusd = pkgs.python3.pkgs.openusd;
    };
  };
}
