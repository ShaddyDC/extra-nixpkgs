{
  buildPythonPackage,
  pythonPkgs,
  fetchFromGitHub,
  pkgs,
  ...
}:
buildPythonPackage rec {
  pname = "pye57";
  version = "0.4.1";
  src = fetchFromGitHub {
    owner = "davidcaron";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IEkd+UhGYunNrHuO/3WN2rI7dofX/oj3vfn3rvyHMHM=";
    fetchSubmodules = true;
  };

  format = "pyproject";

  propagatedBuildInputs = with pythonPkgs; [
    # Specify dependencies
    setuptools
    numpy
    pyquaternion
  ];

  nativeBuildInputs = with pkgs; [
    xercesc
  ];
  buildInputs = with pkgs; [
    xercesc
    pythonPkgs.pybind11
  ];
}
