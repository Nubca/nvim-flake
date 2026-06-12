# Current Project State

This repository builds a personal Neovim distribution as a Nix flake. It uses
`mnw` as the Neovim wrapper, `npins` for plugin source locks, and Lua modules
under `lua/` and `after/` for the editor behavior.

## Main Entry Points

- `flake.nix` defines the flake inputs, formatter, development shell, and
  packages.
- `config.nix` is the `mnw` configuration consumed by
  `mnw.lib.wrap { inherit pkgs inputs; } ./config.nix`.
- `start.json` pins start plugins.
- `opt.json` pins optional/lazy-loaded plugins.
- `packages/blink-cmp/package.nix` packages `blink.cmp` separately from npins.
- `lua/gerg/` contains always-loaded Lua configuration.
- `lua/lazy/` contains `lz.n` plugin specs.
- `after/lsp/` contains Neovim LSP server configuration files.

## Nix And Plugin Flow

The wrapped Neovim package is exposed as:

```console
nix build .#neovim
nix run .#neovim
```

`config.nix` uses `neovim-nightly` as the Neovim binary and enables Ruby,
Python, Node.js, and Perl providers. Runtime command dependencies are added via
`extraBinPath`, currently including `deadnix`, `statix`, `nil`,
`lua-language-server`, `stylua`, `ripgrep`, `fd`, `chafa`, and
`vscode-langservers-extracted`.

Plugins are split by load strategy:

- `plugins.startAttrs` reads `start.json`.
- `plugins.optAttrs` reads `opt.json` and overlays the locally packaged
  `blink.cmp`.
- `plugins.start` also includes all Treesitter grammar dependencies from
  `pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies`.
- `plugins.dev.gerg` exposes this repo's `lua/` and `after/` trees to Neovim.

The editor initialization order in `config.nix` is:

```lua
require("gerg")
LZN = require("lz.n")
LZN.register_handler(require("handlers.which-key"))
LZN.load("lazy")
```

That means base settings load first, then `lz.n` registers the lazy specs from
`lua/lazy/`.

## npins State

This project intentionally does not use the default `npins/sources.json`
layout. It uses two custom lock files:

```console
npins --lock-file start.json ...
npins --lock-file opt.json ...
```

The flake dev shell provides convenience wrappers:

```console
nix develop
start update
opt update
```

The current `npins` lock schema is version 8. The locked `mnw` revision
supports schema versions 7 and 8 directly through
`mnw.lib.npinsToPluginsAttrs`, so no local compatibility shim is required.

## Updating Dependencies

Manual update flow:

```console
nix flake update
npins --lock-file start.json update
npins --lock-file opt.json update
nix run nixpkgs#nix-update -- -F blink-cmp --version=branch
nix build .#neovim --no-link
```

Inside `nix develop`, the npins commands can be shortened:

```console
start update
opt update
```

The GitHub Actions workflow in `.github/workflows/update_deps.yaml` performs
the same broad maintenance categories on a schedule:

- `nix flake update`
- `npins` updates for `start.json` and `opt.json`
- `nix-update` for `blink-cmp`

### Temporary Neovim CVE Patch Workaround

As of June 12, 2026, `config.nix` filters
`CVE-2026-11487.patch` from the `neovim-nightly` derivation. Nixpkgs revision
`9ae611a455b90cf061d8f332b977e387bda8e1ca` backports that fix, but nightly
Neovim revision `3ed78daf83aa88003f52234e6b493c9718b2d987` already contains it, causing
the patch phase to fail because the patch was previously applied.

After updating `nixpkgs` and `neovim-nightly`, test whether the workaround can
be removed. Restore the normal configuration:

```nix
inherit (inputs.neovim-nightly.packages.${pkgs.stdenv.system}) neovim;
```

Then run `nix build .#neovim --no-link`. Keep the simpler configuration if it
builds; the workaround is no longer necessary once nixpkgs stops adding the
backport to a nightly source that already includes the fix.

## Neovim Configuration Shape

Base editor settings live in `lua/gerg/misc.lua`. Notable behavior:

- Space is the leader key.
- `which-key` is initialized globally as `WK`.
- Window movement over wrapped lines remaps `j` and `k` to `gj` and `gk` when
  no count is given.
- Mouse support, relative numbers, cursor line/column, spellcheck, undo files,
  and system clipboard are enabled.
- The `moonfly` colorscheme is used outside VS Code.
- Missing parent directories are created automatically before save.
- Markdown-like buffers disable Treesitter folding/context because those
  combinations have been unstable in this config.

Treesitter setup is split between:

- `lua/gerg/treesitter.lua` for core startup and disabling markdown-like
  buffers.
- `lua/lazy/treesitter.lua` for `nvim-treesitter`, textobjects,
  `treesitter-context`, `ts_context_commentstring`, rainbow delimiters, and
  `indent-blankline`.

Lazy plugin specs live in `lua/lazy/*.lua` and are loaded by `lz.n`. The specs
use fields such as `event`, `ft`, `cmd`, `keys`, `wk`, `before`, and `after`.
Dependencies are usually triggered explicitly with `LZN.trigger_load(...)` in a
`before` hook.

## Adding Or Changing Plugins

For a normal GitHub plugin:

```console
npins --lock-file opt.json add github OWNER REPO --branch BRANCH
```

Then add a matching `lua/lazy/<plugin>.lua` spec. Use the existing `lz.n` style:

```lua
return {
  "plugin-name.nvim",
  event = "DeferredUIEnter",
  before = function()
    LZN.trigger_load("dependency.nvim")
  end,
  after = function()
    require("plugin-name").setup({})
  end,
}
```

Use `start.json` only for plugins that must be available at startup or are
foundational to the lazy-loading system. Most feature plugins should go in
`opt.json`.

If a plugin has native build constraints or should be built from a nonstandard
source, prefer a package under `packages/` and overlay it into `optAttrs`, as
currently done for `blink.cmp`.

## LSP And Completion

`lua/lazy/lsp.lua` loads `nvim-lspconfig`, `none-ls.nvim`, and `crates.nvim`.
The active LSP servers are enabled with:

```lua
vim.lsp.enable({ "nil_ls", "lua_ls", "ccls", "jsonls" })
```

Server-specific files live under `after/lsp/`.

Completion is configured in `lua/lazy/blink.lua`. `blink.cmp` is loaded on
`DeferredUIEnter`, integrates with `lazydev`, uses `lspkind` and
`nvim-web-devicons` for icons, and uses the Rust fuzzy implementation.

`blink.cmp` v2 and `blink.lib` are version-coupled. Because `blink.cmp` is
packaged separately in `packages/blink-cmp/package.nix`, keep the `blink.lib`
pin in `start.json` aligned with the `blink-lib` revision in that exact
`blink.cmp` source revision's `flake.lock`. Updating `blink.lib` independently
can cause configuration-schema errors such as valid keymap entries being
reported as unknown fields. The `blink.lib` pin is currently frozen so routine
`start update` runs cannot advance it independently. Update and refreeze it
only when updating the packaged `blink.cmp` revision in lockstep.

## Verification

Useful checks after edits:

```console
npins --lock-file start.json show
npins --lock-file opt.json show
nix eval .#packages.x86_64-linux.neovim.pname
nix build .#neovim --no-link
```

For Lua/Nix formatting:

```console
nix fmt
```

The formatter currently expects directory arguments or no arguments because it
uses `fd` internally. For formatting individual Nix files, use:

```console
nix shell nixpkgs#nixfmt -c nixfmt path/to/file.nix
```

## Operational Notes For Codex

- This repo is usually edited directly at `/files1/Sources/nvim-flake`.
- New files must be tracked or staged before Nix flake evaluation can see them.
- Do not run `npins init` here; this project uses `start.json` and `opt.json`.
- Keep the locked `mnw` revision compatible with the current npins schema.
- Prefer small changes and verify with `nix eval` before a full build.
- Use the existing `lz.n` spec style instead of introducing another plugin
  manager.
