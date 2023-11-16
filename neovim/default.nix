{ nixvim
, pkgs
, system
, config
, lib
, ...
}:
let
  defaultConfig = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    options = {
      number = true;
      scrolloff = 15;
      hlsearch = false;
      updatetime = 20;
      autoread = true;
      tabstop = 4;
      shiftwidth = 2;
      expandtab = true;
    };
    colorschemes.catppuccin = {
      enable = true;
      flavour = "mocha";
      transparentBackground = true;
      integrations = {
        cmp = true;
        gitsigns = true;
        treesitter = true;
        telescope = true;
        markdown = true;
      };
    };
    keymaps = [
      {
        mode = [ "n" "v" ];
        key = "<Space>";
        action = "<Nop>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<Tab>";
        action = "<cmd>BufferNext<cr>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<S-Tab>";
        action = "<cmd>BufferPrevious<cr>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>x";
        action = "<cmd>BufferClose<cr>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>/";
        action = "require('Comment.api').toggle.linewise.current";
        lua = true;
        options.silent = true;
      }
      {
        mode = "v";
        key = "<leader>/";
        action = "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>";
        options.silent = true;
      }
      {
        mode = [ "n" "t" ];
        key = "<leader>h";
        action = "<cmd>ToggleTerm<cr>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "require('telescope.builtin').find_files";
        lua = true;
      }
      {
        mode = "n";
        key = "<leader>fw";
        action = "require('telescope.builtin').live_grep";
        lua = true;
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "vim.diagnostic.open_float";
        lua = true;
      }
      {
        mode = "n";
        key = "<leader>ca";
        action = "vim.lsp.buf.code_action";
        lua = true;
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>ca";
        action = "vim.lsp.buf.rename";
        lua = true;
        options.silent = true;
      }
      {
        mode = "n";
        key = "gd";
        action = "vim.lsp.buf.definition";
        lua = true;
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>lf";
        action = "vim.lsp.buf.format";
        lua = true;
        options.silent = true;
      }
      {
        mode = "n";
        key = "K";
        action = "vim.lsp.buf.hover";
        lua = true;
        options.silent = true;
      }
      {
        mode = "n";
        key = "gr";
        action = "require('telescope.builtin').lsp_references";
        lua = true;
        options.silent = true;
      }
    ];
    plugins = {
      lsp = {
        enable = true;
        servers.nixd = {
          enable = true;
          settings.formatting.command = "nixpkgs-fmt";
        };
        onAttach = ''
          if client.server_capabilities.documentHighlightProvider then
              vim.api.nvim_create_autocmd("CursorHold", {
                  buffer = bufnr,
                  callback = function()
                      vim.lsp.buf.document_highlight()
                  end,
              })
              vim.api.nvim_create_autocmd("CursorMoved", {
                  buffer = bufnr,
                  callback = function()
                      vim.lsp.buf.clear_references()
                  end,
              })
          end
        '';
        capabilities = ''
          require("cmp_nvim_lsp").default_capabilities()
        '';
      };
      nvim-cmp = {
        enable = true;
        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<C-Space>" = "cmp.mapping.complete()";
        };
        snippet.expand = "luasnip";
      };
      nvim-cmp.sources = [
        { name = "nvim_lsp"; }
        { name = "luasnip"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
      lualine = {
        enable = true;
        theme = "catppuccin";
      };
      cmp-spell.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp_luasnip.enable = true;
      barbar.enable = true;
      luasnip.enable = true;
      telescope.enable = true;
      gitsigns.enable = true;
      toggleterm.enable = true;
      comment-nvim.enable = true;
      treesitter.enable = true;
      ts-autotag.enable = true;
    };
  };
in
nixvim.legacyPackages."${system}".makeNixvim (lib.recursiveUpdate defaultConfig config)
