{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  makeWrapper,
  handbrake,
  makemkv,
  ffmpeg-full,
  abcde,
  flac,
  imagemagick,
  cdparanoia,
  lsdvd,
  eject,
  git,
  wget,
  at,
  which,
  util-linux,
  gawk,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      alembic
      apprise
      bcrypt
      discid
      flask
      flask-cors
      flask-login
      flask-migrate
      flask-sqlalchemy
      flask-wtf
      # greenlet # dependency of sqlalchemy
      # idna # dependency of requests
      # itsdangerous # dependency of flask
      # jinja2 # dependency of flask
      # mako # dependency of alembic
      # markdown # dependency of ...? adding it just in case
      # markupsafe # dependency of jinja2
      musicbrainzngs
      netifaces
      prettytable
      psutil
      pkgs.custom.pydvdid # This might need a custom package definition if not in nixpkgs
      pyyaml
      pyudev
      requests
      # sqlalchemy # dependency of flask-sqlalchemy
      # urllib3 # dependency of requests
      waitress
      # werkzeug # dependency of flask
      # wtforms # dependency of flask-wtf
      xmltodict
      # Dependencies from original file, not in requirements.txt
      mutagen
      rich
      colorama
    ]
  );

  runtimeDeps = [
    handbrake
    makemkv
    ffmpeg-full
    abcde
    flac
    imagemagick
    cdparanoia
    lsdvd
    eject
    git
    wget
    at
    which
    util-linux
    gawk
  ];

in
stdenv.mkDerivation rec {
  pname = "automatic-ripping-machine";
  version = "2.21.0";

  src = fetchFromGitHub {
    owner = "automatic-ripping-machine";
    repo = "automatic-ripping-machine";
    rev = "${version}";
    fetchSubmodules = true;
    hash = "sha256-8xYP7RarCDoyPDC8hI6yr14/NknZ3N4HcyXCSYHlTfU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    # Make runui.py executable
    sed -i '1i #!/usr/bin/env python3' "arm/runui.py"
    chmod +x "arm/runui.py"

    # Patch config location to be overrideable by an environment variable
    sed -i "1i import os" "arm/config/config.py"
    sed -i "s|CONFIG_LOCATION = \"/etc/arm/config\"|CONFIG_LOCATION = os.environ.get('ARM_CONFIG_DIR', \"/etc/arm/config\")|" "arm/config/config.py"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/automatic-ripping-machine

    # Copy application code
    cp -r arm $out/share/automatic-ripping-machine/
    # Copy setup files which contain default configs
    cp -r setup $out/share/automatic-ripping-machine/

    makeWrapper "${pythonEnv.interpreter}" "$out/bin/arm-ui" \
      --add-flags "$out/share/automatic-ripping-machine/arm/runui.py" \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --prefix PYTHONPATH : "$out/share/automatic-ripping-machine"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Automatic Ripping Machine (ARM)";
    homepage = "https://github.com/automatic-ripping-machine/automatic-ripping-machine";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "arm-ui";
  };
}
