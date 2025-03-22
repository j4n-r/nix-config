{ ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      sort_order = "default";
      width = 800;
      hide_scroll = true;
      lines = 8;
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

      @define-color base            #191724;
      @define-color surface         #1f1d2e;
      @define-color overlay         #26233a;

      @define-color muted           #6e6a86;
      @define-color subtle          #908caa;
      @define-color text            #e0def4;

      @define-color love            #eb6f92;
      @define-color gold            #f6c177;
      @define-color rose            #ebbcba;
      @define-color pine            #31748f;
      @define-color foam            #9ccfd8;
      @define-color iris            #c4a7e7;

      @define-color highlightLow    #21202e;
      @define-color highlightMed    #403d52;
      @define-color highlightHigh   #524f67;

        * {
            color: @text;
          border-color: @base;
        }

        window {
        margin: 3px;
        border: 1px solid @subtle;
        border-radius: 8px;

          background-color: @base;
        }

        #input {
        margin: 5px;
          background-color: @base;
          border-bottom: 1px solid @overlay;
        }

        #inner-box {
        margin: 0px;
          background-color: @base;
        }

        #outer-box {
            margin: 10px 10px 1px 10px;
          background-color: @base;
        }

        #scroll {
        margin: 5px;
          opacity: 0.9;
          background-color: @base;
        }
 
        #text {
            margin: 5px;
        }


        #entry:selected {
          background-color: @iris; 
          border-radius: 4px;
          border: none;
        }
        #text:selected {
          background-color: @iris;
          color: @base;
        }
    '';

  };
}
