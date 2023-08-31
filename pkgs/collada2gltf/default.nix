{
  mkDerivation,
  pkgs,
  fetchFromGitHub,
  fetchpatch,
  ...
}:
# Note that currently draco compression seems to segfault
mkDerivation rec {
  pname = "COLLADA2GLTF";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3Eo1qS6S5vlc/d2WB4iDJTjUnwMUrx9+Ln6n8PYU5qA=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Need to patch used draco version. Recent versions aren't compatible anymore
    cd GLTF/dependencies/draco

    # Part of https://github.com/google/draco/commit/571d547d36a6546854948cfecdd7885a8bfb9c02
    # Required to make patches work
    sed -i '19i\\' src/draco/core/hash_utils.h

    patch -p1 < ${fetchpatch {
      url = "https://github.com/google/draco/pull/636.patch";
      sha256 = "sha256-hnCKqQZ1tQPFLM1qgCVzgikbZj0G3O9H3zbbuePFtdE=";
    }}
    patch -p1 < ${fetchpatch {
      url = "https://github.com/google/draco/pull/708.patch";
      sha256 = "sha256-0bf+gNTp8PJp4seF4qbtPahRMsvESxgMLPxDzTqfI5M=";
    }}

    cd -
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp COLLADA2GLTF-bin $out/bin

    runHook postInstall
  '';

  nativeBuildInputs = with pkgs; [
    cmake
    ninja
  ];
}

