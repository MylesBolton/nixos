{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  libsecret,
  pcsclite,
}:

stdenv.mkDerivation rec {
  pname = "keeper-password-manager";
  version = "17.5.0";

  src = fetchurl {
    url = "https://www.keepersecurity.com/desktop_electron/Linux/repo/deb/keeperpasswordmanager_${version}_amd64.deb";
    hash = "sha256-aezUmacR4FcGRLM/tLpLAnCmt0hWilFLL20NwMPDI/o=";
  };

  nativeBuildInputs = [
    dpkg
  ];

  buildInputs = [
    libsecret
    pcsclite
  ];

  unpackPhase = ''
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/share

    cp -r usr/lib/keeperpasswordmanager $out/lib/
    cp -r usr/share/* $out/share/

    ln -s $out/lib/keeperpasswordmanager/keeperpasswordmanager $out/bin/keeperpasswordmanager

    substituteInPlace $out/share/applications/keeperpasswordmanager.desktop \
      --replace "Exec=/usr/lib/keeperpasswordmanager/keeperpasswordmanager" "Exec=$out/bin/keeperpasswordmanager" \
      --replace "Exec=/opt/keeperpasswordmanager/keeperpasswordmanager" "Exec=$out/bin/keeperpasswordmanager"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Keeper Password Manager Desktop App";
    homepage = "https://keepersecurity.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
  };
}
