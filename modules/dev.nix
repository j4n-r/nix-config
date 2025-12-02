{
  pkgs,
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
      ])
    )
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
    claude-code
    appimage-run

    jetbrains.rust-rover

    gf

    # quickemu
    # spice
    #semgrep

    # build tools
    gcc
    gdb
    clang
    libclang
    llvm
    lld
    cmake
    ninja

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
    aider-chat

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

    nodejs
    yarn
    vscode
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
    # code-cursor
  ];

}
