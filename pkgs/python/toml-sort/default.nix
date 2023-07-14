{
  buildPythonPackage,
  pythonPkgs,
  fetchFromGitHub,
  ...
}:
buildPythonPackage rec {
  pname = "toml-sort";
  version = "0.23.1";
  format = "pyproject";
  src = fetchFromGitHub {
    owner = "pappasam";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7V2WBZYAdsA4Tiy9/2UPOcThSNE3ZXM713j57KDCegk=";
  };
  doCheck = false;
  propagatedBuildInputs = with pythonPkgs; [
    poetry-core
    tomlkit
  ];
}
