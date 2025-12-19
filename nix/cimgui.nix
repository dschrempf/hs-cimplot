{
  lib,
  stdenv,
  fetchFromGitHub,
  #
  cmake,
  pkg-config,
  #
  imgui,
}:

stdenv.mkDerivation rec {
  pname = "cimgui";
  version = "d94ad1b16224a01592ec60f21b284f0883ea9a56";

  src = fetchFromGitHub {
    owner = "cimgui";
    repo = "cimgui";
    rev = version;
    hash = "sha256-T/Z67xZgQFbYPl2ivfSDmN5pc0+Rnd9m5kYHTv4GQOE=";
  };

  meta = with lib; {
    description = "c-api for imgui (https://github.com/ocornut/imgui)";
    homepage = "https://github.com/cimgui/cimgui";
    license = licenses.mit;
    maintainers = with maintainers; [ dschrempf ];
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    imgui
  ];

  prePatch = ''
    substituteInPlace cimgui.cpp \
      --replace-fail '#include "./imgui/imgui.h"' '#include <imgui.h>' \
      --replace-fail '#include "./imgui/imgui_internal.h"' '#include <imgui_internal.h>'
  '';

  installPhase = ''
    mkdir -p $out/include
    cp ../*.h $out/include

    mkdir -p $out/lib
    cp cimgui.so $out/lib

    mkdir -p $out/lib/pkgconfig
    cp ${./cimgui.pc.base} $out/lib/pkgconfig/cimgui.pc
    substituteInPlace $out/lib/pkgconfig/cimgui.pc \
      --replace-fail '@out@' "$out"
  '';
}
