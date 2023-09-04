final: prev:
{
  apple-cursor = prev.callPackage ./apple-cursor.nix { };
  xremap = prev.callPackage ./xremap.nix { };
  goimports-reviser = prev.callPackage ./goimports-reviser.nix { };
  supersonic = prev.callPackage ./supersonic.nix { };

  # rename the script of fup-repl from flake-utils-plus 
  my-fup-repl = final.fup-repl.overrideAttrs (old: {
    buildCommand = old.buildCommand + ''
      mv $out/bin/repl $out/bin/fup-repl
    '';
  });

  # Fix cover art and tray icon
  tauon = prev.tauon.overrideAttrs (old: {
    version = "head";
    src = final.fetchFromGitHub {
      owner = "Taiko2k";
      repo = "TauonMusicBox";
      rev = "f2d683228eeb420171cdde2a7ec0dfb50b376997";
      hash = "sha256-ibGv7IBjhqjyD+glPdBNtQiAXquRqG0eMqGIy58RH8g=";
    };

    buildInputs = old.buildInputs ++ [ final.libappindicator ];

    patches = [ ./tauon.patch ];
  });

  vivaldi = (prev.vivaldi.override {
    commandLineArgs = [
      "--force-dark-mode" # Make prefers-color-scheme selector to choose dark theme
      "--gtk-version=4"
      "--disable-gpu-sandbox"
    ];
    enableWidevine = true;
    widevine-cdm = final.widevine-cdm;
  }).overrideAttrs (old: rec {
    # TODO: upgrade to the latest version when GPU acceleration is working
    version = "6.0.2979.25";
    suffix = "amd64";
    src = final.fetchurl {
      url = "https://downloads.vivaldi.com/stable/vivaldi-stable_${version}-1_${suffix}.deb";
      hash = "sha256-m3N7dvOtRna3FYLZdkPjAfGRF4KAJ8XlDlpGnToAwVY=";
    };
  });
}
