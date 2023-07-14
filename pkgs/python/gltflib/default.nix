{
  buildPythonPackage,
  pythonPkgs,
  fetchFromGitHub,
  ...
}:
buildPythonPackage rec {
  pname = "gltflib";
  version = "1.0.13";
  src = fetchFromGitHub {
    owner = "lukas-shawford";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cD79GXNVne05TQzddiQSEcllhuug7xiMH2tiowhxmhQ=";
  };
  doCheck = false;
  propagatedBuildInputs = with pythonPkgs; [
    setuptools
    dataclasses-json
  ];
}
