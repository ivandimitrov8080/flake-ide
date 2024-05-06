{ nixvim
, pkgs
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
      "workbench.iconTheme" = "vscode-icons";
      "editor.renderWhitespace" = "none";
      "editor.minimap.enabled" = false;
      "editor.renderLineHighlight" = "none";
      "workbench.editor.showTabs" = false;
      "files.autoSave" = "onWindowChange";
      "workbench.colorTheme" = "Catppuccin Mocha";
      "editor.scrollbar.vertical" = "hidden";
      "editor.scrollbar.horizontal" = "hidden";
    };

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
