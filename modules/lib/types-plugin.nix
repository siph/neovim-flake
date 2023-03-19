{lib}:
with lib; let
  # Plugin must be same as input name
  availablePlugins = [
    "bufdelete-nvim"
    "catppuccin"
    "cellular-automaton"
    "cmp-buffer"
    "cmp-nvim-lsp"
    "cmp-path"
    "cmp-treesitter"
    "cmp-vsnip"
    "crates-nvim"
    "gitsigns-nvim"
    "glow-nvim"
    "gruvbox"
    "indent-blankline"
    "lsp-signature"
    "lspkind"
    "lspsaga"
    "lualine"
    "null-ls"
    "nvim-autopairs"
    "nvim-bufferline-lua"
    "nvim-cmp"
    "nvim-code-action-menu"
    "nvim-compe"
    "nvim-cursorline"
    "nvim-dap"
    "nvim-dap-ui"
    "nvim-lightbulb"
    "nvim-lspconfig"
    "nvim-nu"
    "nvim-tree-lua"
    "nvim-treesitter"
    "nvim-treesitter-context"
    "nvim-ts-autotag"
    "nvim-web-devicons"
    "onedark"
    "open-browser"
    "plantuml-previewer"
    "plantuml-syntax"
    "plenary-nvim"
    "rust-tools"
    "sqls-nvim"
    "telescope"
    "telescope-dap"
    "tokyonight"
    "trouble"
    "vim-vsnip"
    "which-key"
  ];

  pluginsType = with types; listOf (nullOr (either (enum availablePlugins) package));
in {
  pluginsOpt = {
    description,
    default ? [],
  }:
    mkOption {
      inherit description default;
      type = pluginsType;
    };
}
