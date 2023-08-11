{
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  pkgs,
  pythonPkgs,
  lib,
  sitePackages,
  ...
}: let
  pyside-tools = pkgs.stdenv.mkDerivation rec {
    pname = "pyside-tools";
    version = "6.5.0";
    # src = ./.;
    src = fetchurl {
      # https://download.qt.io/official_releases/QtForPython/shiboken6/
      url = "https://download.qt.io/official_releases/QtForPython/shiboken6/PySide6-${version}-src/pyside-setup-everywhere-src-${version}.tar.xz";
      sha256 = "sha256-bvU7KRJyZ+OBkX5vk5nOdg7cBkTNWDGYix3nLJ1YOrQ=";
    };

    sourceRoot = "pyside-setup-everywhere-src-${lib.versions.majorMinor version}/sources/${pname}";

    cmakeFlags = [
      "-DBUILD_TESTS=OFF"
    ];

    nativeBuildInputs = with pythonPkgs;
      [
      ]
      ++ (with pkgs; [
        cmake
        ninja
      ]);
    buildInputs = with pkgs.qt6; [
      # required
      qtbase
      # optional
      qt3d
      qtcharts
      qtconnectivity
      qtdatavis3d
      qtdeclarative
      qthttpserver
      qtmultimedia
      qtnetworkauth
      qtquick3d
      qtremoteobjects
      qtscxml
      qtsensors
      qtspeech
      qtsvg
      qttools
      qtwebchannel
      qtwebengine
      qtwebsockets
    ];
    postInstall = ''
      cp $out/bin/uic $out/bin/pyside6-uic
    '';

    dontWrapQtApps = true;
  };
in
  buildPythonPackage rec {
    pname = "OpenUSD";
    version = "23.05";
    src = fetchFromGitHub {
      owner = "PixarAnimationStudios";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-3wM6stJnpznTU7Lb0vAdeO0/cr8n9rhvPZgT7PGAe04=";
    };

    postPatch = ''
      substituteInPlace "cmake/macros/Private.cmake" \
        --replace '"''${pysideUicBinName}" STREQUAL "uic"' "TRUE"
    '';

    patches = [
      ./usd-pyside6.patch
    ];

    format = "other";

    propagatedBuildInputs = with pythonPkgs; [
      setuptools
      pyqt5
      pyopengl
      jinja2
      pyside6
      pyside-tools
      boost
      numpy
    ];

    cmakeFlags = [
      "-DPXR_BUILD_TESTS=OFF"
      "-DPXR_BUILD_EXAMPLES=OFF"
      "-DPXR_BUILD_TUTORIALS=OFF"
      "-DPXR_BUILD_USD_TOOLS=ON"
      "-DPXR_BUILD_IMAGING=ON"
      "-DPXR_BUILD_USD_IMAGING=ON"
      "-DPXR_BUILD_USDVIEW=ON"
      "-DPXR_BUILD_PYTHON_DOCUMENTATION=ON"
      "-DPXR_BUILD_DOCUMENTATION=ON"
    ];

    nativeBuildInputs = with pythonPkgs;
      [
      ]
      ++ (with pkgs; [
        cmake
        ninja
        git
        qt6.wrapQtAppsHook
        doxygen
        graphviz
      ]);
    buildInputs = with pkgs; [
      tbb

      opensubdiv
      openimageio
      opencolorio
      osl
      ptex
      embree
      # RenderMan
      alembic
      openexr
      # MaterialX
      flex
      bison
      boost

      pysideApiextractor
      qt6.qtbase
    ];

    pythonImportsCheck = ["pxr" "pxr.Usd"];

    postInstall = ''
      mkdir -p $out/${sitePackages}
      cp -r $out/lib/python/* $out/${sitePackages}/
    '';
  }
