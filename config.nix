{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  npinsToPluginsAttrs =
    pkgs: path: ((pkgs.callPackage ./npins-to-plugins.nix { }) builtins.mapAttrs) path;
in
{
  inherit (inputs.neovim-nightly.packages.${pkgs.stdenv.system}) neovim;

  appName = "gerg";

  extraLuaPackages = p: [ p.jsregexp ];

  providers = {
    ruby.enable = true;
    python3.enable = true;
    nodeJs.enable = true;
    perl.enable = true;
  };

  # Source lua config
  initLua = ''
    require("gerg")
    LZN = require("lz.n")
    LZN.register_handler(require("handlers.which-key"))
    LZN.load("lazy")
  '';

  desktopEntry = false;
  plugins = {
    dev.gerg = {
      pure =
        let
          fs = lib.fileset;
        in
        fs.toSource {
          root = ./.;
          fileset = fs.unions [
            ./lua
            ./after
          ];
        };
      impure = "~/Sources/nvim-flake";
    };

    startAttrs = npinsToPluginsAttrs pkgs ./start.json;

    start = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;

    optAttrs = {
      "blink.cmp" = inputs.self.packages.${pkgs.stdenv.system}.blink-cmp;
    }
    // npinsToPluginsAttrs pkgs ./opt.json;
  };

  extraBinPath = builtins.attrValues {
    #
    # Runtime dependencies
    #
    inherit (pkgs)
      deadnix
      statix
      nil

      lua-language-server
      stylua

      ripgrep
      fd
      chafa
      vscode-langservers-extracted
      ;
  };
}
