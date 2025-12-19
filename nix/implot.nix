{
  lib,
  stdenv,
  fetchFromGitHub,
  #
  cmake,
  vcpkg,
  #
  imgui,
}:

stdenv.mkDerivation rec {
  pname = "implot";
  version = "4707b245fbcd69075b1a8a74fa8d2435561b3134";

  src = fetchFromGitHub {
    owner = "epezent";
    repo = "implot";
    rev = version;
    hash = "sha256-HNzNRHPLr352EDkAci4nx5qQnPI308rGH8yHkF+n5OY=";
  };

  meta = with lib; {
    description = "Immediate Mode Plotting";
    homepage = "https://github.com/epezent/implot";
    license = licenses.mit;
    maintainers = with maintainers; [ dschrempf ];
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ imgui ];

  cmakeRules = "${vcpkg.src}/ports/implot";
  postPatch = ''
    cp "$cmakeRules"/CMakeLists.txt ./
  '';
}
