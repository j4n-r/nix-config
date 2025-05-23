{
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    devenv
    btop
    emacs
    libvterm
    (aspellWithDicts (
      dicts: with dicts; [
        en
        en-computers
        en-science
        de
      ]
    ))
    cloc
    comrak

    yaak # api client
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

    cargo
    rustc
    rustfmt
    rust-analyzer
    clippy
    openssl
    pkg-config

    nodejs
    yarn
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
