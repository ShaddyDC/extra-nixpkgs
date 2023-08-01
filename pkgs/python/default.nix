{...}: {
  flake = let
    pythonOverlay = final: prev: {
      python3 = prev.python3.override {
        packageOverrides = final: prev: let
          pythonPkgs = final.pkgs.python3.pkgs;
          python = prev.pkgs.python3;
        in {
         torch = prev.torch.override {
           # identical to pytorchWithCuda but necessary to avoid conflicts
            magma = final.pkgs.magma-cuda-static;
            cudaSupport = true;
            rocmSupport = false;
          };
          toml-sort = python.pkgs.callPackage ./toml-sort {inherit pythonPkgs;};
          connected-components-3d = python.pkgs.callPackage ./connected-components-3d {inherit pythonPkgs;};
          gltflib = python.pkgs.callPackage ./gltflib {inherit pythonPkgs;};
          pymeshlab = python.pkgs.callPackage ./pymeshlab {
            inherit pythonPkgs;
          };
          pye57 = python.pkgs.callPackage ./pye57 {inherit pythonPkgs;};
          Open3D = python.pkgs.callPackage ./Open3D {inherit pythonPkgs;};
        };
      };
    };
  in {
    overlays.pythonOverlay = pythonOverlay;
  };

  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages = {
      python3 = pkgs.python3;
    };
  };
}
