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
        # epkgs.tuareg
      ])
    )
    vscode
    zigpkgs.master
    qemu
    quickemu
    zotero

    pkg-config
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

     ocaml
    dune_3
    ocamlPackages.ocaml-lsp
    ocamlPackages.odoc
    ocamlPackages.ocamlformat
    ocamlPackages.utop

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

    elixir
    elixir-ls
    erlang
    wxGTK32

    go
    gopls
    delve
    gdlv

    cargo
    rustc
    rustfmt
    rust-analyzer
    clippy
    openssl
    pkg-config

    racket

    ghc
    haskell-language-server

    nodejs
    yarn
    pnpm_10

    # lsp & formatter
    nil # nix lsp
    nixfmt-tree
    nixfmt-rfc-style
    nix-index

    typescript-language-server
    typescript
    vscode-langservers-extracted
    tailwindcss
    tailwindcss-language-server
    nodePackages.prettier

    typst
    tinymist
    go
    gopls

    postgresql_17

    
  ];

}
