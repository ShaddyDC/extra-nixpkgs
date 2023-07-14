{
  buildPythonPackage,
  pythonPkgs,
  fetchFromGitHub,
  ...
}:
buildPythonPackage rec {
  pname = "connected-components-3d";
  version = "3.11.0";
  src = fetchFromGitHub {
    owner = "seung-lab";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-0skoVoeRFDsz5XvzRytPOVZ1FYj1tHV1GhyKOnx+DXE=";
  };
  doCheck = false;
  propagatedBuildInputs = with pythonPkgs; [
    pbr
    numpy
    cython
  ];
}
