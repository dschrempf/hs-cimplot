{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "cimplot";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "cimgui";
    repo = "cimplot";
    rev = "$v{version}";
    hash = lib.fakeHash;
  };

  meta = with lib; {
    description = "C binding for implot: https://github.com/epezent/implot";
    homepage = "https://github.com/cimgui/cimplot";
    license = licenses.mit;
    maintainers = with maintainers; [ dschrempf ];
  };

  # nativeBuildInputs = [ ];
  # buildInputs = [ ];
  # propagatedBuildInputs = [ ];
}
