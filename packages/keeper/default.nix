{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  libsecret,
  pcsclite,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  udev,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxcb,
  libglvnd,
  libuuid,
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
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libsecret
    libxkbcommon
    mesa
    nspr
    nss
    pango
    pcsclite
    udev
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libglvnd
    libxcb
    libuuid
  ];

  unpackPhase = ''
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/share

    cp -r usr/lib/keeperpasswordmanager $out/lib/
    cp -r usr/share/* $out/share/

    # FIX: Manually wrap the binary to force LD_LIBRARY_PATH for dlopened libs (libGL)
    makeWrapper $out/lib/keeperpasswordmanager/keeperpasswordmanager $out/bin/keeperpasswordmanager \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libglvnd
          udev
          libuuid
        ]
      }"

    substituteInPlace $out/share/applications/keeperpasswordmanager.desktop \
      --replace "Exec=/usr/lib/keeperpasswordmanager/keeperpasswordmanager" "Exec=$out/bin/keeperpasswordmanager" \
      --replace "Exec=/opt/keeperpasswordmanager/keeperpasswordmanager" "Exec=$out/bin/keeperpasswordmanager"

    runHook postInstall
  '';

  runtimeDependencies = [
    (lib.getLib udev)
    libglvnd
  ];

  meta = with lib; {
    description = "Keeper Password Manager Desktop App";
    homepage = "https://keepersecurity.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
  };
}
