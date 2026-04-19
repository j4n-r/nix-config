{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        vspacecode.vspacecode
        vspacecode.whichkey
        vscodevim.vim
        jgclark.vscode-todo-highlight
        usernamehw.errorlens
        kahole.magit
        mkhl.direnv
        ms-vscode.cpptools-extension-pack
        golang.go
      ];

      userSettings = {
        "workbench.colorTheme" = "Dark Modern";
        "chat.disableAIFeatures" = true;
        "vim.easymotion" = true;
        "vim.useSystemClipboard" = true;

        "vim.normalModeKeyBindingsNonRecursive" = [
          {
            "before" = [ "<space>" ];
            "commands" = [ "vspacecode.space" ];
          }
          {
            "before" = [ "," ];
            "commands" = [
              "vspacecode.space"
              {
                "command" = "whichkey.triggerKey";
                "args" = "m";
              }
            ];
          }
        ];

        "vim.visualModeKeyBindingsNonRecursive" = [
          {
            "before" = [ "<space>" ];
            "commands" = [ "vspacecode.space" ];
          }
          {
            "before" = [ "," ];
            "commands" = [
              "vspacecode.space"
              {
                "command" = "whichkey.triggerKey";
                "args" = "m";
              }
            ];
          }
          {
            "before" = [ ">" ];
            "commands" = [ "editor.action.indentLines" ];
          }
          {
            "before" = [ "<" ];
            "commands" = [ "editor.action.outdentLines" ];
          }
        ];

        "editor.minimap.enabled" = false;
        "window.menuBarVisibility" = "toggle";
        "window.commandCenter" = false;
        "workbench.layoutControl.enabled" = false;
        "zenMode.showTabs" = "none";
        "workbench.editor.showTabs" = "none";
        "editor.lineNumbers" = "relative";
        "whichkey.delay" = 400;

        "vspacecode.bindingOverrides" = [
          {
            "keys" = ",";
            "name" = "Open Buffers";
            "type" = "command";
            "command" = "workbench.action.showAllEditors";
          }
          {
            "keys" = "s.p";
            "name" = "Open Buffers";
            "type" = "command";
            "command" = "workbench.action.quickTextSearch";
          }
          {
            "keys" = "g.g";
            "name" = "Magit";
            "type" = "command";
            "command" = "magit.status";
          }
          {
            "keys" = "w.q";
            "name" = "Window Close";
            "type" = "command";
            "command" = "workbench.action.closeActiveEditor";
          }
        ];

        "todohighlight.isEnable" = true;

        "todohighlight.keywords" = [
          {
            "text" = "TODO:";
            "color" = "#eb6f92";
            "backgroundColor" = "rgba(235, 111, 146, 0.12)";
            "overviewRulerColor" = "#eb6f92";
            "border" = "1px solid rgba(235, 111, 146, 0.50)";
            "borderRadius" = "2px";
            "isWholeLine" = false;
          }
          {
            "text" = "FIXME:";
            "color" = "#eb6f92";
            "backgroundColor" = "rgba(235, 111, 146, 0.12)";
            "overviewRulerColor" = "#eb6f92";
            "border" = "1px solid rgba(235, 111, 146, 0.50)";
            "borderRadius" = "2px";
            "isWholeLine" = false;
          }
          {
            "text" = "BUG:";
            "color" = "#eb6f92";
            "backgroundColor" = "rgba(235, 111, 146, 0.12)";
            "overviewRulerColor" = "#eb6f92";
            "border" = "1px solid rgba(235, 111, 146, 0.50)";
            "borderRadius" = "2px";
            "isWholeLine" = false;
          }
          {
            "text" = "NOTE:";
            "color" = "#9ccfd8";
            "backgroundColor" = "rgba(156, 207, 216, 0.12)";
            "overviewRulerColor" = "#9ccfd8";
            "border" = "1px solid rgba(156, 207, 216, 0.50)";
            "borderRadius" = "2px";
            "isWholeLine" = false;
          }
          {
            "text" = "DEBUG:";
            "color" = "#f6c177";
            "backgroundColor" = "rgba(246, 193, 119, 0.12)";
            "overviewRulerColor" = "#f6c177";
            "border" = "1px solid rgba(246, 193, 119, 0.50)";
            "borderRadius" = "2px";
            "isWholeLine" = false;
          }
        ];

        "todohighlight.include" = [
          "**/*.c"
          "**/*.h"
          "**/*.cpp"
          "**/*.hpp"
          "**/*.rs"
          "**/*.go"
          "**/*.py"
          "**/*.rb"
          "**/*.java"
          "**/*.kt"
          "**/*.swift"
          "**/*.js"
          "**/*.jsx"
          "**/*.ts"
          "**/*.tsx"
          "**/*.php"
          "**/*.lua"
          "**/*.sh"
          "**/*.bash"
          "**/*.zsh"
          "**/*.yml"
          "**/*.yaml"
          "**/*.toml"
          "**/*.json"
          "**/*.md"
        ];

        "todohighlight.exclude" = [
          "**/node_modules/**"
          "**/dist/**"
          "**/build/**"
          "**/.git/**"
          "**/.vscode/**"
          "**/.github/**"
          "**/.next/**"
          "**/target/**"
          "**/*.min.*"
          "**/*.map"
        ];

        "todohighlight.toggleURI" = false;
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'JetBrains Mono', monospace";
        "editor.fontLigatures" = true;
        "editor.inlineSuggest.edits.allowCodeShifting" = "never";

        "editor.quickSuggestions" = {
          "other" = "off";
        };

        "workbench.activityBar.location" = "top";
      };

      keybindings = [
        {
          key = "space";
          command = "vspacecode.space";
          when = "activeEditorGroupEmpty && focusedView == '' && !whichkeyActive && !inputFocus";
        }
        {
          key = "space";
          command = "vspacecode.space";
          when = "sideBarFocus && !inputFocus && !whichkeyActive";
        }
        {
          key = "tab";
          command = "magit.toggle-fold";
          when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
        }
        {
          key = "x";
          command = "magit.discard-at-point";
          when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
        }
        {
          key = "k";
          command = "-magit.discard-at-point";
        }
        {
          key = "-";
          command = "magit.reverse-at-point";
          when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
        }
        {
          key = "v";
          command = "-magit.reverse-at-point";
        }
        {
          key = "shift+-";
          command = "magit.reverting";
          when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
        }
        {
          key = "shift+v";
          command = "-magit.reverting";
        }
        {
          key = "shift+o";
          command = "magit.resetting";
          when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
        }
        {
          key = "shift+x";
          command = "-magit.resetting";
        }
        {
          key = "x";
          command = "-magit.reset-mixed";
        }
        {
          key = "ctrl+u x";
          command = "-magit.reset-hard";
        }
        {
          key = "y";
          command = "-magit.show-refs";
        }
        {
          key = "y";
          command = "vspacecode.showMagitRefMenu";
          when = "editorTextFocus && editorLangId == 'magit' && vim.mode == 'Normal'";
        }
        {
          key = "g";
          command = "-magit.refresh";
          when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
        }
        {
          key = "g";
          command = "vspacecode.showMagitRefreshMenu";
          when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
        }
        {
          key = "ctrl+j";
          command = "workbench.action.quickOpenSelectNext";
          when = "inQuickOpen";
        }
        {
          key = "ctrl+k";
          command = "workbench.action.quickOpenSelectPrevious";
          when = "inQuickOpen";
        }
        {
          key = "ctrl+j";
          command = "selectNextSuggestion";
          when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
        }
        {
          key = "ctrl+k";
          command = "selectPrevSuggestion";
          when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
        }
        {
          key = "ctrl+l";
          command = "acceptSelectedSuggestion";
          when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
        }
        {
          key = "ctrl+j";
          command = "showNextParameterHint";
          when = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
        }
        {
          key = "ctrl+k";
          command = "showPrevParameterHint";
          when = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
        }
        {
          key = "ctrl+j";
          command = "selectNextCodeAction";
          when = "codeActionMenuVisible";
        }
        {
          key = "ctrl+k";
          command = "selectPrevCodeAction";
          when = "codeActionMenuVisible";
        }
        {
          key = "ctrl+l";
          command = "acceptSelectedCodeAction";
          when = "codeActionMenuVisible";
        }
        {
          key = "ctrl+h";
          command = "file-browser.stepOut";
          when = "inFileBrowser";
        }
        {
          key = "ctrl+l";
          command = "file-browser.stepIn";
          when = "inFileBrowser";
        }
        {
          key = "ctrl+i";
          command = "acceptSelectedSuggestion";
          when = "suggestWidgetVisible && editorTextFocus";
        }
        {
          key = "ctrl+tab";
          command = "editor.action.triggerSuggest";
          when = "editorTextFocus";
        }
        {
          key = "f9";
          command = "workbench.action.debug.continue";
        }
        {
          key = "f8";
          command = "workbench.action.debug.stepOver";
        }
        {
          key = "f7";
          command = "workbench.action.debug.stepInto";
        }
        {
          key = "shift+f8";
          command = "workbench.action.debug.stepOut";
        }
        {
          key = "f5";
          command = "editor.debug.action.toggleBreakpoint";
        }
        {
          key = "alt+l";
          command = "workbench.action.debug.continue";
          when = "inDebugMode";
        }
        {
          key = "alt+j";
          command = "workbench.action.debug.stepOver";
          when = "inDebugMode";
        }
        {
          key = "alt+k";
          command = "workbench.action.debug.stepInto";
          when = "inDebugMode";
        }
        {
          key = "alt+h";
          command = "workbench.action.debug.stepOut";
          when = "inDebugMode";
        }
      ];
    };
  };
}
