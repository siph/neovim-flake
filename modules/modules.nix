{
  pkgs,
  lib,
  check ? true,
}: let
  modules = [
    ./autopairs
    ./basic
    ./completion
    ./core
    ./debugging
    ./filetree
    ./git
    ./keys
    ./lsp
    ./markdown
    ./plantuml
    ./snippets
    ./statusline
    ./tabline
    ./telescope
    ./theme
    ./tidal
    ./treesitter
    ./visuals
  ];

  pkgsModule = {config, ...}: {
    config = {
      _module.args.baseModules = modules;
      _module.args.pkgsPath = lib.mkDefault pkgs.path;
      _module.args.pkgs = lib.mkDefault pkgs;
      _module.check = check;
    };
  };
in
  modules ++ [pkgsModule]
