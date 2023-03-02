{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.debugging;
in {
  options.vim.debugging = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = "enable debugging with nvim-dap";
    };

    ui = mkOption {
      default = false;
      type = types.bool;
      description = "enable better debugging interface";
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
        "nvim-dap"
        (
          if cfg.ui
          then "nvim-dap-ui"
          else null
        )
      ];
      vim.luaConfigRC.debugging = nvim.dag.entryAnywhere ''
        -- Nvim-Dap config
        local dap = require("dap")
        ${writeIf cfg.ui ''
          -- Nvim-Dap-Ui config
          require("dapui").setup {}
        ''}
      '';
    }
  );
}
