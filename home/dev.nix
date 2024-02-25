{
  pkgs,
  lib,
  hostPlatform,
  ...
}: {
  home.packages = with pkgs;
    [
      git-lfs

      jq
      fx
      htop

      cloc

      ninja
      clang-tools

      (fenix.stable.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
      rust-analyzer

      golines
      gofumpt
      golangci-lint
      impl
      reftools
      delve
      gomodifytags

      vtsls

      deadnix
      nvd

      python3
    ]
    ++ (with python3Packages; [
      ipython
      black
      pylint
      isort

      # Markdown preview
      # TODO: Enable this after it builds
      # grip
    ])
    ++ lib.optionals hostPlatform.isLinux [
      file
    ]
    ++ lib.optionals hostPlatform.isDarwin [
      (pkgs.writeShellScriptBin "gsed" "exec -a $0 ${gnused}/bin/sed $@")
    ];

  programs.go = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Lite Ye";
    userEmail = "yelite958@gmail.com";
  };
}
