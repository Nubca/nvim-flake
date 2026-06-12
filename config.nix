{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  neovim = inputs.neovim-nightly.packages.${pkgs.stdenv.system}.neovim.overrideAttrs (old: {
    # The nightly source already contains this fix, so the nixpkgs backport no
    # longer applies until nixpkgs removes it from the Neovim package.
    patches = builtins.filter (
      patch: !lib.hasSuffix "-CVE-2026-11487.patch" (toString patch)
    ) old.patches;
  });

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

    startAttrs = inputs.mnw.lib.npinsToPluginsAttrs pkgs ./start.json;

    start = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;

    optAttrs = {
      "blink.cmp" = inputs.self.packages.${pkgs.stdenv.system}.blink-cmp;
    }
    // inputs.mnw.lib.npinsToPluginsAttrs pkgs ./opt.json;
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
