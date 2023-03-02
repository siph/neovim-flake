{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./nvim-dap.nix
  ];
}
