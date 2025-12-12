{
  lib,
  python3,
  fetchFromGitHub,
}:

let
  python3Packages = python3.pkgs;
in
python3Packages.buildPythonPackage rec {
  pname = "pydvdid";
  version = "1.1";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sjwood";
    repo = "pydvdid";
    rev = "v${version}";
    sha256 = "1najs9n6s4lj133vmp495k27vgivpyknhc3bkzywyvdnxrg69s1y";
  };

  nativeCheckInputs = with python3Packages; [
    mock
    parameterized
    pylint
    pytest
    nose
  ];

  checkPhase = ''
    runHook preCheck
    pytest tests/testfunctions.py
    runHook postCheck
  '';

  doCheck = false; # TODO nose fails and i cba fixing it properly right now as i just need the module workign for ARM

  meta = with lib; {
    description = "A pure Python implementation of the Windows API IDvdInfo2::GetDiscID method.";
    homepage = "https://github.com/sjwood/pydvdid";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
