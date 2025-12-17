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
      flask
      flask-sqlalchemy
      flask-migrate
      flask-cors
      flask-wtf
      flask-login
      psutil
      requests
      pyudev
      musicbrainzngs
      mutagen
      apprise
      netifaces
      pyyaml
      waitress
      bcrypt
      xmltodict
      alembic
      prettytable
      rich
      discid
      pkgs.custom.pydvdid
    ]
  );

  runtimeDeps = [
    pythonEnv
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
    hash = "sha256-vJmsBu/5dW0x9ngC5ySOPkQ1s+d+3teSiGrgEoAo4ok=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ pythonEnv ];

  postPatch = ''
    sed -i '1i #!/usr/bin/env python3' "arm/runui.py"
    grep -rl "/opt/arm" . --exclude="*.rules" | xargs sed -i "s|/opt/arm|$out/opt/arm|g"
    sed -i "s|/opt/arm/scripts/thickclient/arm_venv_wrapper.sh|__ARM_WRAPPER_PATH__|g" "setup/51-automatic-ripping-machine-venv.rules"

    sed -i "1i import os" "arm/config/config.py"
    sed -i "s|CONFIG_LOCATION = \"/etc/arm/config\"|CONFIG_LOCATION = os.environ.get('ARM_CONFIG_DIR', '/etc/arm/config')|" "arm/config/config.py"

    # Patch wrapper script
    sed -i 's|/opt/arm/venv/bin/python3|python3|g' "scripts/thickclient/arm_venv_wrapper.sh"
    sed -i 's|/usr/bin/python3|python3|g' "scripts/thickclient/arm_wrapper.sh"
    sed -i 's|/etc/arm/config/arm.yaml|/var/lib/arm/config/arm.yaml|' "scripts/thickclient/arm_venv_wrapper.sh"
    sed -i 's|/bin/su -l|/bin/su -p|' "scripts/thickclient/arm_venv_wrapper.sh"
    sed -i 's|echo python3|echo \\$(which python3)|' "scripts/thickclient/arm_venv_wrapper.sh"
    sed -i '/if ! pgrep -f "runui.py"/, /fi/d' "scripts/thickclient/arm_venv_wrapper.sh"

    #CD-ROM Rule
    echo 'SUBSYSTEM=="block", KERNEL=="sr0", ENV{UDISKS_IGNORE}="1"' >> setup/51-automatic-ripping-machine-venv.rules
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/arm
    mkdir -p $out/bin
    mkdir -p $out/lib/udev/rules.d

    cp -r ./* $out/opt/arm/

    chmod +x $out/opt/arm/arm/runui.py
    find $out/opt/arm/scripts -name "*.sh" -exec chmod +x {} \;

    cp setup/51-automatic-ripping-machine-venv.rules $out/lib/udev/rules.d/51-automatic-ripping-machine.rules

    sed -i "s|__ARM_WRAPPER_PATH__|$out/bin/arm_wrapper|g" $out/lib/udev/rules.d/51-automatic-ripping-machine.rules

    runHook postInstall
  '';

  postFixup = ''
    patchShebangs $out/opt/arm

    makeWrapper "$out/opt/arm/scripts/thickclient/arm_venv_wrapper.sh" "$out/bin/arm_wrapper" \
    --prefix PATH : ${lib.makeBinPath runtimeDeps} \
    --prefix PYTHONPATH : "$out/opt/arm"

    makeWrapper "$out/opt/arm/arm/runui.py" "$out/bin/arm-ui" \
    --prefix PATH : ${lib.makeBinPath runtimeDeps} \
    --prefix PYTHONPATH : "$out/opt/arm"
  '';

  meta = with lib; {
    description = "Automatic Ripping Machine (ARM)";
    homepage = "https://github.com/automatic-ripping-machine/automatic-ripping-machine";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
