{
  lib,
  hostPlatform,
  buildGoModule,
  fetchFromGitHub,
  darwin,
  fyne,
  makeWrapper,
  pkg-config,
  libX11,
  libXrandr,
  libXinerama,
  libXcursor,
  libXi,
  libXext,
  libGL,
  mesa,
  mpv,
}:
buildGoModule rec {
  pname = "supersonic";
  version = "0.9.0";
  src = fetchFromGitHub {
    owner = "dweymouth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QHDTbcWSEFleMsjt4BR4xt6DlqPSowUbHmi4+83c0kc=";
  };

  nativeBuildInputs = [pkg-config makeWrapper fyne];

  buildInputs =
    [
      mpv
    ]
    ++ lib.optionals hostPlatform.isLinux [
      libX11
      libXrandr
      libXinerama
      libXcursor
      libXi
      libXext
      libGL
      mesa.dev
    ]
    ++ lib.optionals hostPlatform.isDarwin [
      # darwin.CarbonHeaders
      darwin.apple_sdk.frameworks.Cocoa
      darwin.apple_sdk.frameworks.Kernel
      darwin.apple_sdk.frameworks.UserNotifications
      darwin.apple_sdk.frameworks.MediaPlayer
    ];

  postInstall =
    ''
      wrapProgram "$out/bin/supersonic" --set FYNE_SCALE 2
    ''
    + lib.optionalString hostPlatform.isDarwin ''
      mkdir -p $out/Applications

      fyne package -os darwin -name Supersonic -appVersion ${version} -icon ./res/appicon-512.png
      cp $out/bin/supersonic Supersonic.app/Contents/MacOS/
      mv Supersonic.app $out/Applications
    '';

  vendorHash = "sha256-ANVkQpCnPsRueHyxRJMY5cqMZ5Q/QMVW4KS+TFYMpUQ=";

  meta = {
    homepage = "https://github.com/dweymouth/supersonic";
    description = "A lightweight cross-platform desktop client for Subsonic music servers";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
