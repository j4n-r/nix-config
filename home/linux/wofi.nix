{ ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      sort_order = "default";
      width = 500;
      hide_scroll = true;
      lines = 5;
      term = "ghostty";
      line_wrap = "word";
      allow_markup = true;
      always_parse_args = false;
      show_all = true;
      print_command = true;
      layer = "overlay";
      allow_images = true;
      gtk_dark = true;
      prompt = "Search";
      image_size = 24;
      display_generic = false;
      location = "center";
      insensitive = true;
    };
    style = ''
      * {
        font-family: JetBrainsMono;
        color: #e0def4;
      }

      #outer-box {
        padding: 20px;
      }

      #window {
        background: #191724;
        margin: auto;
        padding: 10px;
        border-radius: 15;
        /* border: 2px solid #89b4fa; */
          opacity: 0.9;
      }

      #input {
        padding: 10px 20px;
        margin-bottom: 10px;
        border-radius: 15;
      }

      #img {
        margin-right: 6px;
      }

      #text {
        margin: 2px;
          background: none;
      }

      #entry {
        padding: 10px;
        border-radius: 15;
        border: none;
      }

      #entry:selected {
        background-color: #313244;
        outline: none;
        border: none;

      }
      #img:selected {
          background: none;
      }

    '';

  };
}
