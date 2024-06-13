{ nixvim
, system
, lib
, ...
}:
let
  defaultConfig = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    userSettings = {
      "editor.tabSize" = 2;
      "editor.fontSize" = 14;
      "editor.formatOnSave" = true;
      "workbench.iconTheme" = "catppuccin-mocha";
      "editor.renderWhitespace" = "none";
      "editor.minimap.enabled" = false;
      "editor.renderLineHighlight" = "none";
      "workbench.editor.showTabs" = "multiple";
      "files.autoSave" = "onWindowChange";
      "workbench.colorTheme" = "Catppuccin Mocha";
      "editor.scrollbar.vertical" = "hidden";
      "editor.scrollbar.horizontal" = "hidden";
      "vim.easymotion" = true;
      "vim.incsearch" = true;
      "vim.useSystemClipboard" = true;
      "vim.useCtrlKeys" = true;
      "vim.hlsearch" = true;
      "vim.normalModeKeyBindings" = [
        {
          before = [ "<leader>" "f" "w" ];
          commands = [ "search.action.openEditor" ];
        }
        {
          before = [ "<leader>" "x" ];
          commands = [ "workbench.action.closeActiveEditor" ];
        }
      ];
      "vim.leader" = "<space>";
      "vim.handleKeys" = {
        "<C-a>" = false;
        "<C-f>" = false;
      };
      "extensions.experimental.affinity" = {
        "vscodevim.vim" = 1;
      };
    };
    keybindings = [
      { key = "tab"; command = "workbench.action.nextEditor"; }
      { key = "shift+tab"; command = "workbench.action.previousEditor"; }
    ];
  };
in
{
  standalone = cfg: nixvim.legacyPackages."${system}".makeNixvim (lib.recursiveUpdate defaultConfig cfg);
  homecode = cfg:
    {
      programs.vscode = (lib.recursiveUpdate defaultConfig cfg);
    }
  ;
}
