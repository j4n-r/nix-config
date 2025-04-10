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

    # build tools
    gcc
    clang
    llvm
    lld
    cmake
    ninja

    # for more complex things use shell.nix
    pyright
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        pandas
        python-lsp-server
        ruff
        numpy
        requests
      ]
    ))

    cargo
    rustc
    rustfmt
    rust-analyzer
    clippy

    # languages
    nodejs

    # lsp & formatter
    nil # nix lsp
    nixfmt-rfc-style

    typescript-language-server
    typescript
    vscode-langservers-extracted
    tailwindcss-language-server
    nodePackages.prettier

    go
    gopls

  ];

}
