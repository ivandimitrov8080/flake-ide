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
  colorschemes.catppuccin = {
    enable = true;
    flavour = "mocha";
    transparentBackground = true;
  };
  plugins = {
    treesitter = {
      enable = true;
    };
    ts-autotag = {
      enable = true;
    };
    lsp = {
      enable = true;
      onAttach = ''
        function(client, bufnr)
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
    luasnip = {
      enable = true;
    };
    lualine = {
      enable = true;
    };
    telescope = {
      enable = true;
      extraOptions = {
        defaults =
          {
            file_ignore_patterns = [ "hosts" ];
          };
      };
    };
    gitsigns = {
      enable = true;
    };
    toggleterm = {
      enable = true;
    };
    comment-nvim = {
      enable = true;
    };
  };
}
