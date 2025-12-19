{
  lib,
  stdenv,
  fetchFromGitHub,
  #
  cmake,
  vcpkg,
}:

stdenv.mkDerivation rec {
  pname = "implot";
  version = "4707b245fbcd69075b1a8a74fa8d2435561b3134";

  src = fetchFromGitHub {
    owner = "epezent";
    repo = "implot";
    rev = version;
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  meta = with lib; {
    description = "Immediate Mode Plotting";
    homepage = "https://github.com/epezent/implot";
    license = licenses.mit;
    maintainers = with maintainers; [ dschrempf ];
  };

  cmakeRules = "${vcpkg.src}/ports/implot";
  postPatch = ''
    cp "$cmakeRules"/CMakeLists.txt ./
  '';

  prePatch = ''
    # substituteInPlace cimplot.h \
    #   --replace-fail '#include "cimgui.h"' '#include <cimgui.h>'

    # substituteInPlace cimplot.cpp \
    #   --replace-fail '#include "./implot/implot.h"' '#include <implot.h>'
  '';

  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [ ];
}
