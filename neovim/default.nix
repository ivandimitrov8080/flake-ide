{ nixvim
, pkgs
, system
, lib
, ...
}:
let
  defaultConfig = {
    enableMan = false;
    package = pkgs.neovim;
    viAlias = true;
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    opts = {
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
      settings = {
        flavour = "mocha";
        transparent_background = true;
        integrations = {
          cmp = true;
          gitsigns = true;
          treesitter = true;
          telescope = {
            enabled = true;
          };
          markdown = true;
        };
      };
    };
    keymaps = [
      {
        mode = [ "n" "v" ];
        key = "<Space>";
        action = "<Nop>";
        options = { silent = true; desc = "Don't map the leader key"; };
      }
      {
        mode = "n";
        key = "<Tab>";
        action = "<cmd>BufferNext<cr>";
        options = { silent = true; desc = "Switch tabs forwards"; };
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<cmd>move +1<cr>";
        options = { silent = true; desc = "Move current line down by 1"; };
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<cmd>move -2<cr>";
        options = { silent = true; desc = "Move current line up by 1"; };
      }
      {
        mode = "n";
        key = "<S-Tab>";
        action = "<cmd>BufferPrevious<cr>";
        options = { silent = true; desc = "Switch tabs backwards"; };
      }
      {
        mode = "n";
        key = "<leader>x";
        action = "<cmd>BufferClose<cr>";
        options = { silent = true; desc = "Close current buffer"; };
      }
      {
        mode = "n";
        key = "<leader>/";
        action.__raw = "require('Comment.api').toggle.linewise.current";
        options = { silent = true; desc = "Comment out the current line"; };
      }
      {
        mode = "v";
        key = "<leader>/";
        action = "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>";
        options = { silent = true; desc = "Comment out the selection"; };
      }
      {
        mode = [ "n" "t" ];
        key = "<leader>h";
        action = "<cmd>ToggleTerm<cr>";
        options = { silent = true; desc = "Open a terminal"; };
      }
      {
        mode = "n";
        key = "<leader>ff";
        action.__raw = "require('telescope.builtin').find_files";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fw";
        action.__raw = "require('telescope.builtin').live_grep";
        options.desc = "Find words";
      }
      {
        mode = "n";
        key = "gr";
        action.__raw = "require('telescope.builtin').lsp_references";
        options.desc = "Go to references";
      }
      {
        mode = "n";
        key = "gi";
        action.__raw = "require('telescope.builtin').lsp_implementations";
        options.desc = "Go to implementations";
      }
      {
        mode = "n";
        key = "gd";
        action.__raw = "require('telescope.builtin').lsp_definitions";
        options.desc = "Go to definitions";
      }
      {
        mode = "n";
        key = "gt";
        action.__raw = "require('telescope.builtin').lsp_type_definitions";
        options.desc = "Go to type definitions";
      }
      {
        mode = "n";
        key = "<leader>e";
        action.__raw = "vim.diagnostic.open_float";
        options.desc = "Open diagnostics";
      }
      {
        mode = "n";
        key = "<leader>ca";
        action.__raw = "vim.lsp.buf.code_action";
        options = { silent = true; desc = "Code action"; };
      }
      {
        mode = "n";
        key = "<leader>lr";
        action.__raw = "vim.lsp.buf.rename";
        options = { silent = true; desc = "LSP Rename"; };
      }
      {
        mode = "n";
        key = "<leader>lf";
        action.__raw = "vim.lsp.buf.format";
        options = { silent = true; desc = "Format buffer"; };
      }
      {
        mode = "n";
        key = "<leader>tt";
        action = "<cmd>TodoTelescope<cr>";
        options = { silent = true; desc = "Show Todo Telescope"; };
      }
      {
        mode = "n";
        key = "<leader>r";
        action = "<cmd>!make run<cr>";
        options = { silent = true; desc = "Run `make run`"; };
      }
    ];
    plugins = {
      barbar.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-spell.enable = true;
      comment.enable = true;
      gitsigns.enable = true;
      luasnip.enable = true;
      nvim-autopairs.enable = true;
      telescope.enable = true;
      toggleterm.enable = true;
      ts-autotag.enable = true;
      web-devicons.enable = true;
      diffview = {
        enable = true;
        package = pkgs.vimPlugins.diffview-nvim.overrideAttrs (final: prev: {
          version = "2024-05-24";
        });
      };
      treesitter = {
        enable = true;
        settings = {
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = "<C-a>";
              node_incremental = "<C-a>";
              scope_incremental = "<C-s>";
              node_decremental = "<C-d>";
            };
          };
        };
      };
      which-key.enable = true;
      todo-comments.enable = true;
      lsp = {
        enable = true;
        servers = {
          nixd = {
            enable = true;
            settings.formatting.command = [ "nixpkgs-fmt" ];
          };
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

          --

          local languages = { 'bash' }
          local completion = true
          local diagnostics = true
          local tsquery = nil
        '';
        capabilities = ''
          require("cmp_nvim_lsp").default_capabilities()
        '';
        keymaps = {
          lspBuf = {
            K = "hover";
          };
        };
      };
      cmp = {
        enable = true;
        settings = {
          snippet.expand = "function(args) vim.snippet.expand(args.body) end";
          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'});
                ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'});
              })
            '';
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "catppuccin";
          };
        };
      };
    };
  };
in
rec {
  default = cfg: nixvim.legacyPackages."${system}".makeNixvim (lib.recursiveUpdate defaultConfig cfg);
  c = cfg: default (lib.recursiveUpdate { plugins.lsp.servers.clangd.enable = true; } cfg);
  homevim = cfg: {
    imports = [ nixvim.homeManagerModules.nixvim ];
    programs.nixvim = (lib.recursiveUpdate defaultConfig cfg);
  }
  ;
}
