{ pkgs, ... }:

let
  # Dark theme collection for Typora, installed into ~/.config/Typora/themes.
  # Revisions pinned at 2026-09-22.

  graphite-void = pkgs.fetchFromGitHub {
    owner = "vofo";
    repo = "typora-theme-graphite-void";
    rev = "0a7a47cd185ebbdabee97d6e70ee76e7fafdf2cc";
    hash = "sha256-ZF1XkuktrY7SJNaZRNZSlkbjpXofMjajb6iRc1L5Fjc=";
  };

  rose-pine = pkgs.fetchFromGitHub {
    owner = "rose-pine";
    repo = "typora";
    rev = "eff3f88fb74216634a9b7300058a20aa2d7996e0";
    hash = "sha256-6W1hvB46FZyfHtYPldFnJcAu8cOcKvXl058klH7663Y=";
  };

  opencode-themes = pkgs.fetchFromGitHub {
    owner = "nxxxsooo";
    repo = "opencode-themes";
    rev = "1e60308d27ee9e31e6d5749b24d307c61b7db911";
    hash = "sha256-v1/wkOQbD9AA27rEcnrSa6N8STIwU29BK0Y7s3KlJXg=";
  };

  bonne-nouvelle = pkgs.fetchFromGitHub {
    owner = "senges";
    repo = "typora-bonne-nouvelle";
    rev = "11c81115dbe662e8dcb6e3db8e371233aa9f6678";
    hash = "sha256-LpWp9X47rH2TEgfevktdrrVVEa5R354+YKoVPHw0uzE=";
  };

  notion-style = pkgs.fetchFromGitHub {
    owner = "s1m4ne";
    repo = "typora-theme-notion-style";
    rev = "acd8dc988170cb5f9acf910cf254198e29c62bb3";
    hash = "sha256-I0BJw6aYnKKMF7b8ncR5FaOdp2VPBuyyiJGJhMXQDkI=";
  };

  see-yue-zip = pkgs.fetchurl {
    url = "https://github.com/jinghu-moon/typora-see-yue-theme/releases/download/v1.4/typora-see-yue-theme_v1.4.zip";
    hash = "sha256-pNKIpYhfGLBX3vxGjmiM86VJjYFfycF2BvDQwLzPXjQ=";
  };

  see-yue = pkgs.runCommand "typora-see-yue-theme" { nativeBuildInputs = [ pkgs.unzip ]; } ''
    unzip -q ${see-yue-zip} 'see-yue-dark.css' 'SeeYue/*' -d $out
  '';

  kiro-zip = pkgs.fetchurl {
    url = "https://github.com/mooonu/typora-kiro-theme/releases/download/v1.0.0/kiro-typora-theme-v1.0.0.zip";
    hash = "sha256-WGgV4zAauuKhQbi746GTqeUjbkjCCkuwhfYKsUb0n8E=";
  };

  kiro = pkgs.runCommand "typora-kiro-theme" { nativeBuildInputs = [ pkgs.unzip ]; } ''
    unzip -q ${kiro-zip} 'kiro.css' 'kiro/*' -d $out
    # Upstream release references kiro-dark/ and non-NL JetBrains Mono filenames.
    sed -i 's|kiro-dark/|kiro/|g; s|JetBrainsMono-|JetBrainsMonoNL-|g' $out/kiro.css
  '';
in
{
  xdg.configFile = {
    "Typora/themes/graphite-void.css".source = "${graphite-void}/vofo-graphite-void.css";

    "Typora/themes/rosé-pine.css".source = "${rose-pine}/rosé-pine.css";
    "Typora/themes/rosepine".source = "${rose-pine}/rosepine";

    "Typora/themes/see-yue-dark.css".source = "${see-yue}/see-yue-dark.css";
    "Typora/themes/SeeYue".source = "${see-yue}/SeeYue";

    "Typora/themes/opencode.css".source = "${opencode-themes}/typora/opencode.css";

    "Typora/themes/kiro.css".source = "${kiro}/kiro.css";
    "Typora/themes/kiro".source = "${kiro}/kiro";

    "Typora/themes/bonne-nouvelle.css".source = "${bonne-nouvelle}/bonne-nouvelle.css";

    "Typora/themes/notion-style-dark.css".source = "${notion-style}/notion-style-dark.css";
  };
}
