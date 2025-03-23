{
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
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
    cmake
    ninja

    # for more complex things use shell.nix
    pyright
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        pandas
        numpy
        requests
      ]
    ))

    cargo
    rustc
    rust-analyzer

    # languages
    nodejs

    # lsp & formatter
    nil # nix lsp
    nixfmt-rfc-style

    typescript-language-server
    typescript
    vscode-langservers-extracted
    tailwindcss-language-server

    go
    gopls

  ];

}
