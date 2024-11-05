{
  mkDerivation,
  pkgs,
  fetchFromGitHub,
  ...
}:
with pkgs; let
  glc-lib = mkDerivation rec {
    pname = "GLC_lib";
    version = "3.0.1-2023-01-02";
    src = fetchFromGitHub {
      owner = "laumaya";
      repo = pname;
      rev = "382230b26374c5737cebd41fa7a08849acd85b46";
      hash = "sha256-qfqsq3Kxe2zMc+VYbWuHlXaHfYCNkxXRQNF4sGwHrjI=";
    };
    postPatch = ''
      # Fix install directories
      substituteInPlace install.pri \
        --replace-fail "/usr/local" "$out" \
        --replace-fail "/usr" "$out"

      # Don't build examples
      substituteInPlace glc_lib.pro \
        --replace-fail "src/plugins" "src/plugins #" \
        --replace-fail "src/examples" ""

      # Fix system quazip linking and building
      sed -i -e '1iINCLUDEPATH += ${libsForQt5.quazip.dev}/include/QuaZip-Qt5-1.4' src/lib/lib.pro
      substituteInPlace src/lib/lib.pro \
        --replace-fail "-lquazip5" "-L${libsForQt5.quazip}/lib -lquazip1-qt5"
      substituteInPlace src/lib/shading/glc_texture.cpp \
        --replace-fail '#include "quazip5' '#include "quazip'
    '';

    patches = [
      # Use system quazip
      (pkgs.fetchpatch {
        # https://github.com/laumaya/GLC_lib/pull/43
        url = "https://github.com/laumaya/GLC_lib/commit/bb604254f5400388c6b15036ff7dddc2b9ef282e.patch?full_index=1";
        hash = "sha256-NXw+r7UJkepZpnDmyCF60dngtraIsVXccaQcq/lwvFU=";
      })
    ];

    buildPhase = ''
      runHook preBuild

      ${qt5.qtbase.dev}/bin/qmake -recursive
      make -j$NIX_BUILD_CORES

      runHook postBuild
    '';

    buildInputs = [
      libGL
      qt5.qtbase
      qt5.wrapQtAppsHook
      libsForQt5.quazip
      zlib
    ];
  };
in
  mkDerivation {
    pname = "glc-player";
    version = "2.3.0-next-2019-12-02";

    src = fetchFromGitHub {
      owner = "laumaya";
      repo = "GLC_Player";
      rev = "f09f4dfb8416dc90cbe54962926d162169d50f6c";
      hash = "sha256-6ZRc3KDnxTsZuPUEsj8rZsw004dc4my7lJ0Cp37Q7uU=";
    };

    nativeBuildInputs = with pkgs; [
      qt5.qtbase
      qt5.wrapQtAppsHook
    ];

    patches = [
      (pkgs.fetchpatch {
        # https://github.com/laumaya/GLC_Player/pull/10
        url = "https://github.com/laumaya/GLC_Player/commit/c457a73c165257cc141d085a7d1ee2788f4a3eae.patch?full_index=1";
        hash = "sha256-xh7QdCTHADixS5qOdxIEdJUabteeC1OWsRp8IegiuaA=";
      })
    ];

    postPatch = ''
      substituteInPlace glc_player.pro \
        --replace-fail "/usr/local/include/GLC_lib-3.0" "${glc-lib}/include/GLC_lib-3.0" \
        --replace-fail "/usr/local/lib"  "${glc-lib}/lib" \
        --replace-fail "-lGLC_lib.3"  "-lGLC_lib"
    '';

    buildPhase = ''
      runHook preBuild

      ${qt5.qtbase.dev}/bin/qmake -recursive
      make -j$NIX_BUILD_CORES

      runHook postBuild
    '';

    postInstall = ''
      install -D -m755 glc_player $out/bin/glc-player
    '';
  }
