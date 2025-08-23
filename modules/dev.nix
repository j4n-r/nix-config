{
  pkgs,
  ...
}:
{
  nixpkgs.config.android_sdk.accept_license = true;
  environment.systemPackages = with pkgs; [
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
    pkg-config
    semgrep
    devenv
    btop
    tokei
    comrak
    claude-code

    # quickemu
    # spice
    #semgrep

    # build tools
    gcc
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
    nixfmt-rfc-style

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
