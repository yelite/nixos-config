{ inputs }:

final: prev: {
  apple-cursor = prev.callPackage ./apple-cursor.nix { };
}
