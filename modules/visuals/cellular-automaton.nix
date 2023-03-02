{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals;
in {
  options.vim.visuals = {
    cellular-automaton = {
      enable = mkOption {
        type = types.bool;
        description = "Make text explode";
      };
    };
  };

  config =
    mkIf cfg.enable
    {
      vim.startPlugins = [
        (
          if cfg.cellular-automaton.enable
          then "cellular-automaton"
          else null
        )
      ];
      vim.luaConfigRC.cellular-automaton = nvim.dag.entryAnywhere ''
        ${
          if cfg.cellular-automaton.enable
          then ''
            vim.keymap.set("n", "<leader>fuckyou", "<cmd>CellularAutomaton make_it_rain<CR>")
            vim.keymap.set("n", "<leader>fuckit", "<cmd>CellularAutomaton game_of_life<CR>")
          ''
          else ""
        }
      '';
    };
}
