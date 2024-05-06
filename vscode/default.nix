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
      "editor.renderWhitespace" = "all";
      "editor.minimap.enabled" = false;
      "editor.renderLineHighlight" = "none";
      "editor.mouseWheelZoom" = true;
      "workbench.layoutControl.type" = "menu";
      "workbench.editor.limit.enabled" = true;
      "workbench.editor.limit.value" = 1;
      "workbench.editor.limit.perEditorGroup" = true;
      "workbench.editor.showTabs" = false;
      "files.autoSave" = "onWindowChange";
      "explorer.openEditors.visible" = 0;
      "breadcrumbs.enabled" = false;
      "editor.renderControlCharacters" = false;
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.activityBar.visible" = false;
      "workbench.statusBar.visible" = false;
      "editor.scrollbar.verticalScrollbarSize" = 2;
      "editor.scrollbar.horizontalScrollbarSize" = 2;
      "editor.scrollbar.vertical" = "hidden";
      "editor.scrollbar.horizontal" = "hidden";
      "workbench.layoutControl.enabled" = false;
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
