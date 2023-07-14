{
  buildPythonPackage,
  pythonPkgs,
  fetchPypi,
  pkgs,
  ...
}:
# let
#   nbformat-570 = pythonPkgs.nbformat.overridePythonAttrs (old: rec {
#     version = "5.7.0";
#     JUPYTER_PLATFORM_DIRS = 1;
#     src = fetchPypi {
#       inherit version;
#       pname = old.pname;
#       hash = "sha256-HUdgwVwaBCae9crzdb6LmN0vaW5eueYD7Cvwkfmw0/M=";
#     };
#   });
#   pytorchSplitCuda = pkgs.pytorchWithCuda.overridePythonAttrs (old: rec {
#     preConfigure =
#       old.preConfigure
#       + ''
#         export BUILD_SPLIT_CUDA=1
#       '';
#   });
# in
## Based on https://github.com/NixOS/nixpkgs/issues/115218#issuecomment-1578342266
buildPythonPackage rec {
  pname = "open3d";
  version = "0.17.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "sha256-PcMAaXMgu2iCRsXQn2gQRYFcMyIlaFc/GWSy11ZDFlc=";
    dist = "cp310";
    python = "cp310";
    abi = "cp310";
    platform = "manylinux_2_27_x86_64";
  };

  nativeBuildInputs = [
    pkgs.autoPatchelfHook
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libtorch_cuda_cpp.so"
    "libtorch_cuda_cu.so"
  ];

  # Fix llvm library name to match Ubuntu name
  # Remove libraries that actually should be provided by environment
  postInstall = ''
    ln -s "${pkgs.llvm_10.lib}/lib/libLLVM-10.so" "$out/lib/libLLVM-10.so.1"

    rm $out/lib/python3.10/site-packages/open3d/libGL.so.1
    rm $out/lib/python3.10/site-packages/open3d/swrast_dri.so
    rm $out/lib/python3.10/site-packages/open3d/libgallium_dri.so
    rm $out/lib/python3.10/site-packages/open3d/kms_swrast_dri.so
    rm $out/lib/python3.10/site-packages/open3d/libEGL.so.1
  '';

  buildInputs = with pkgs; [
    stdenv.cc.cc.lib
    libusb.out
    libGL
    cudaPackages.cudatoolkit
    libtorch-bin
    libtensorflow
    expat
    xorg.libXfixes
    pythonPkgs.pythonRelaxDepsHook
    pythonPkgs.nbformat
  ];
  pythonRemoveDeps = ["nbformat"];

  propagatedBuildInputs = with pythonPkgs; [
    # py deps
    numpy
    dash
    configargparse
    scikit-learn
    ipywidgets
    addict
    matplotlib
    pandas
    pyyaml
    tqdm
    pyquaternion
    pytorchWithCuda
  ];
}
