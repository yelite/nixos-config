{
  lib,
  hostPlatform,
  buildGoModule,
  fetchFromGitHub,
  darwin,
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
  version = "0.7.0";
  src = fetchFromGitHub {
    owner = "dweymouth";
    repo = pname;
    rev = "v0.7.0";
    sha256 = "sha256-DVduZ1qPbcDlH+B5hibC2HUjwEUV+CpDDpMI8GdPwro=";
  };

  nativeBuildInputs = [pkg-config makeWrapper];

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
    ];

  postInstall = ''
    wrapProgram "$out/bin/supersonic" --set FYNE_SCALE 2
  '';

  vendorSha256 = "sha256-Dj6I+gt0gB5HWTWdFXCV5UpLuvg+HhuygRJAdvV/Yp8=";

  meta = {
    homepage = "https://github.com/dweymouth/supersonic";
    description = "A lightweight cross-platform desktop client for Subsonic music servers";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
