{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    hunspell
    hunspellDicts.en_US
    hunspellDicts.de_DE
    enchant
    (aspellWithDicts (
      dicts: with dicts; [
        en
        en-computers
        en-science
        de
      ]
    ))
  ];

  home.file.".config/enchant/enchant.ordering".text = ''
    en_US:aspell,hunspell
    en:aspell,hunspell
    de:aspell,hunspell
    *:hunspell,aspell
  '';
}
