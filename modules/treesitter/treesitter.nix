{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.treesitter;
in {
  options.vim.treesitter = {
    enable = mkOption {
      type = types.bool;
      description = "enable tree-sitter [nvim-treesitter]";
    };

    fold = mkOption {
      type = types.bool;
      description = "enable fold with tree-sitter";
    };

    autotagHtml = mkOption {
      type = types.bool;
      description = "enable autoclose and rename html tag [nvim-ts-autotag]";
    };

    rainbow = {
      enable = mkOption {
        type = types.bool;
        description = "enable tree-sitter-rainbow [nvim-ts-rainbow]";
      };
    };
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg:
        if cond
        then msg
        else "";
    in {
      vim.startPlugins = with pkgs.neovimPlugins; [
        nvim-treesitter
        pkgs.vimPlugins.nvim-ts-rainbow
        (
          if cfg.autotagHtml
          then nvim-ts-autotag
          else null
        )
      ];

      vim.configRC = writeIf cfg.fold ''
        " Tree-sitter based folding
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set nofoldenable
      '';

      vim.luaConfigRC = let
      in ''
        -- Treesitter config
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
            disable = {},
          },

          ${writeIf cfg.rainbow.enable ''
            rainbow = {
              enable = true,
              extended_mode = true,
              max_file_lines = 10000,
              colors = {
                "#b16286",
                "#076678",
                "#458588",
                "#689d6a",
                "#d79921",
                "#d65d0e",
                "#cc241d"
              }
          },
        ''}
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnn",
              node_incremental = "grn",
              scope_incremental = "grc",
              node_decremental = "grm",
            },
          },

          ${writeIf cfg.autotagHtml ''
          autotag = {
            enable = true,
          },
        ''}
        }

        local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
      '';
    }
  );
}
