{
  lib,
  stdenv,
  fetchFromGitHub,
  #
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "cimgui";
  version = "d94ad1b16224a01592ec60f21b284f0883ea9a56";

  src = fetchFromGitHub {
    owner = "cimgui";
    repo = "cimgui";
    rev = version;
    hash = "sha256-yWCGfckPxweclczvsWFWTryps7rCSrj8G1lrzAQ3Z7g=";
    fetchSubmodules = true;
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
  propagatedBuildInputs = [

  ];
}
