{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.config.android_sdk.accept_license = true;

  environment.systemPackages = with pkgs; [
    cachix
    (
      (emacs-unstable.override {
        withNativeCompilation = true;
      }).pkgs.withPackages
      (epkgs: [
        epkgs.vterm
        epkgs.jinx
        epkgs.pdf-tools
        epkgs.lsp-grammarly
      ])
    )
    vscode
    zigpkgs.master
    qemu
    quickemu
    zotero

    pkg-config
    nodejs
    semgrep
    devenv
    btop
    tokei
    comrak

    gcc
    gdb
    clang
    libclang
    gnumake
    llvm
    lld
    cmake
    ninja

    jujutsu

    pandoc
    go-grip

    zed-editor

    nixd
    nixfmt
    alejandra
    
    
     ocaml
    dune_3

ydotool    
    
    basedpyright
    uv
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        pandas
        ruff
        numpy
        requests
        debugpy
      ]
    ))

    go
    gopls
    delve
    gdlv

    openssl
    pkg-config

    # lsp & formatter
    nil # nix lsp
    nixfmt
    nixfmt-tree
    nix-index
    
    typst
    tinymist
    postgresql_17
    
  ];

}
