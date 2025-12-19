{
  lib,
  stdenv,
  fetchFromGitHub,
  #
  cmake,
  pkg-config,
  #
  imgui,
  implot,
  cimgui,
}:

stdenv.mkDerivation rec {
  pname = "cimplot";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "cimgui";
    repo = "cimplot";
    rev = "v${version}";
    hash = "sha256-Wca0zkyMYnADHXP9he6BO6Rr8FabTuRm743XjAYoYKw=";
  };

  meta = with lib; {
    description = "C binding for implot: https://github.com/epezent/implot";
    homepage = "https://github.com/cimgui/cimplot";
    license = licenses.mit;
    maintainers = with maintainers; [ dschrempf ];
  };

  prePatch = ''
    substituteInPlace cimplot.cpp \
      --replace-fail '#include "./implot/implot.h"' '#include <implot.h>' \
      --replace-fail '#include "./implot/implot_internal.h"' '#include <implot_internal.h>'

    substituteInPlace cimplot.h \
      --replace-fail '#include "cimgui.h"' '#include <cimgui.h>'
  '';

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)" \
      --replace-fail 'add_definitions("-DIMGUI_USER_CONFIG=\"../cimconfig.h\"")' ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    imgui
    implot
    cimgui
  ];
  # propagatedBuildInputs = [ ];
}
