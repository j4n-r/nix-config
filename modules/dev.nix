{
  pkgs,
  ...
}:
{
  nixpkgs.config.android_sdk.accept_license = true;
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    devenv
    btop
    emacs
    emacsPackages.jinx
    tokei
    comrak

    # quickemu
    # spice
    #semgrep

    # build tools
    gcc
    clang
    llvm
    lld
    cmake
    ninja

    basedpyright
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

    go
    gopls

    postgresql_17
    # code-cursor
  ];

}
