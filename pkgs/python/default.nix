{...}: {
  perSystem = {pkgs, ...}: {
    packages = let
      makePackage = python: let
        python' = python.override {
          packageOverrides = let
            pythonPkgs = python.pkgs;
          in
            self: super: {
              toml-sort = python.pkgs.callPackage ./toml-sort {inherit pythonPkgs;};
              connected-components-3d = python.pkgs.callPackage ./connected-components-3d {inherit pythonPkgs;};
              gltflib = python.pkgs.callPackage ./gltflib {inherit pythonPkgs;};
              pymeshlab = python.pkgs.callPackage ./pymeshlab {
                inherit pythonPkgs;
                python = python';
              };
              pye57 = python.pkgs.callPackage ./pye57 {inherit pythonPkgs;};
              Open3D = python.pkgs.callPackage ./Open3D {inherit pythonPkgs;};
            };
        };
      in {pkgs = python'.pkgs // {inherit (python'.pkgs) toml-sort connected-components-3d;};};
    in {
      python3 = pkgs.python3 // (makePackage pkgs.python3);
      python39 = pkgs.python39 // (makePackage pkgs.python39);
      python310 = pkgs.python310 // (makePackage pkgs.python310);
    };
  };
}
