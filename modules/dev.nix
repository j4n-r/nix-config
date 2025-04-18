{
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    devenv
    btop
    emacs
    (aspellWithDicts (
      dicts: with dicts; [
        en
        en-computers
        en-science
        de
      ]
    ))
    cloc
    #semgrep

    # build tools
    gcc
    clang
    llvm
    lld
    cmake
    ninja

    # for more complex things use shell.nix
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        pandas
        python-lsp-server
        jedi
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

    # languages
    nodejs

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

    code-cursor
  ];

}
