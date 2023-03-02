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
      default = false;
      type = types.bool;
      description = "enable tree-sitter [nvim-treesitter]";
    };

    fold = mkOption {
      default = false;
      type = types.bool;
      description = "enable fold with tree-sitter";
    };

    autotagHtml = mkOption {
      default = false;
      type = types.bool;
      description = "enable autoclose and rename html tag [nvim-ts-autotag]";
    };

    rainbow = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "enable tree-sitter-rainbow [nvim-ts-rainbow]";
      };
    };

    grammars = mkOption {
      type = with types; listOf package;
      default = with (pkgs.vimPlugins.nvim-treesitter.builtGrammars); [
        c
        comment
        cpp
        css
        graphql
        html
        java
        javascript
        json
        kotlin
        lua
        make
        markdown-inline
        nix
        python
        rust
        toml
        tsx
        zig
      ];
      description = ''
        List of treesitter grammars to install.
        When enabling a language, its treesitter grammar is added for you.
      '';
    };
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg:
        if cond
        then msg
        else "";
    in {
      vim.startPlugins = [
        "nvim-treesitter"
        pkgs.vimPlugins.nvim-ts-rainbow
        (
          if cfg.autotagHtml
          then "nvim-ts-autotag"
          else null
        )
      ];

      # For some reason treesitter highlighting does not work on start if this is set before syntax on
      vim.configRC.treesitter = writeIf cfg.fold (nvim.dag.entryBefore ["basic"] ''
        " Tree-sitter based folding
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set nofoldenable
      '');

      vim.luaConfigRC.treesitter = nvim.dag.entryAnywhere ''
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

          auto_install = false,
          ensure_installed = {},

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
      '';
    }
  );
}
