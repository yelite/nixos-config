{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, xorg
, enableX11 ? false
, enableHypr ? false
}:

assert !(enableX11 && enableHypr);
rustPlatform.buildRustPackage rec {
  pname = "xremap";
  version = "a22b48";

  src = fetchFromGitHub {
    owner = "k0kubun";
    repo = pname;
    rev = "a22b4846d4f78edd0e582950e7e13359f302bb1d";
    sha256 = "sha256-VLbFd+3en/Syy48j2IFMitwqP/S0PNxdokLXQLqDLaQ=";
  };

  cargoSha256 = "sha256-P+jjyHqYCU5knCkN/2Ftu230q4/ZlYJFFekEdAfBoMc=";

  buildFeatures = lib.optional enableX11 "x11"
    ++ lib.optional enableHypr "hypr";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals enableX11 [
    xorg.libX11
  ];

  meta = {
    description = "Dynamic key remapper for X11 and Wayland";
    homepage = "https://github.com/k0kubun/xremap";
  };
}
