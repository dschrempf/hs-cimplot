{
  lib,
  stdenv,
  fetchFromGitHub,
  #
  cmake,
  vcpkg,
}:

stdenv.mkDerivation rec {
  pname = "imgui";
  version = "3912b3d9a9c1b3f17431aebafd86d2f40ee6e59c";

  src = fetchFromGitHub {
    owner = "ocornut";
    repo = "imgui";
    rev = version;
    hash = "sha256-/jVT7+874LCeSF/pdNVTFoSOfRisSqxCJnt5/SGCXPQ=";
  };

  meta = with lib; {
    description = "Bloat-free Graphical User interface for C++";
    homepage = "https://github.com/ocornut/imgui/tree/3912b3d9a9c1b3f17431aebafd86d2f40ee6e59c";
    license = licenses.mit;
    maintainers = with maintainers; [ dschrempf ];
  };

  cmakeRules = "${vcpkg.src}/ports/imgui";
  postPatch = ''
    cp "$cmakeRules"/{CMakeLists.txt,*.cmake.in} ./
  '';
  nativeBuildInputs = [ cmake ];
}
