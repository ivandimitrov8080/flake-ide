{ nixvim
, nixpkgs
, system
, ...
}:
let
  pkgs = nixpkgs.legacyPackages.${system};
in
nixvim.legacyPackages."${system}".makeNixvim
{
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
      action = "<Nop>";
      key = "<Space>";
      options.silent = true;
    }
    {
      mode = "n";
      action = "<cmd>BufferNext<cr>";
      key = "<Tab>";
      options.silent = true;
    }
    {
      mode = "n";
      action = "<cmd>BufferPrevious<cr>";
      key = "<S-Tab>";
      options.silent = true;
    }
    {
      mode = "n";
      action = "<cmd>BufferClose<cr>";
      key = "<leader>x";
      options.silent = true;
    }
    {
      mode = "n";
      action = "require('Comment.api').toggle.linewise.current";
      lua = true;
      key = "<leader>/";
      options.silent = true;
    }
    {
      mode = "v";
      action = "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>";
      key = "<leader>/";
      options.silent = true;
    }
    {
      mode = [ "n" "t" ];
      action = "<cmd>ToggleTerm<cr>";
      key = "<leader>h";
      options.silent = true;
    }
    {
      mode = "n";
      action = "require('telescope.builtin').find_files";
      lua = true;
      key = "<leader>ff";
    }
    {
      mode = "n";
      action = "require('telescope.builtin').live_grep";
      lua = true;
      key = "<leader>fw";
    }
    {
      mode = "n";
      action = "vim.diagnostic.open_float";
      lua = true;
      key = "<leader>e";
    }
  ];
  plugins = {
    lsp = {
      enable = true;
      onAttach = ''
        nmap("<leader>ca", vim.lsp.buf.code_action)
        nmap("<leader>lr", vim.lsp.buf.rename)
        nmap("gd", vim.lsp.buf.definition)
        nmap("<leader>lf", function()
            vim.lsp.buf.format()
        end)
        nmap("K", vim.lsp.buf.hover)
        nmap("gr", require("telescope.builtin").lsp_references)
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
      servers = {
        nixd.enable = true;
      };
    };
    nvim-cmp = {
      enable = true;
      mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<C-Space>" = "cmp.mapping.complete()";
      };
    };
    lualine = {
      enable = true;
      theme = "catppuccin";
    };
    barbar.enable = true;
    cmp-nvim-lsp.enable = true;
    luasnip.enable = true;
    telescope.enable = true;
    gitsigns.enable = true;
    toggleterm.enable = true;
    comment-nvim.enable = true;
    treesitter.enable = true;
    ts-autotag.enable = true;
  };
}
