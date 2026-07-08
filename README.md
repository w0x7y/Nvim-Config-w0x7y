# Nvim-Config-w0x7y

A personal Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim), with LSP, autocompletion, formatting, fuzzy finding, and a handful of quality-of-life plugins.

## ✨ Features

- 🎨 **Theme** — [OneDarkPro](https://github.com/olimorris/onedarkpro.nvim)
- 🔍 **Fuzzy finding** — [Telescope](https://github.com/nvim-telescope/telescope.nvim) for files, live grep, and buffers
- 🌳 **Syntax highlighting** — [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- 🧠 **LSP** — managed via [mason.nvim](https://github.com/williamboman/mason.nvim), [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim), and [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- 🛠️ **Auto-installed tools** — [mason-tool-installer](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) keeps LSPs and formatters up to date
- 🧹 **Formatting on save** — [conform.nvim](https://github.com/stevearc/conform.nvim)
- ⌨️ **Autocompletion** — [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) with LuaSnip snippets
- 📊 **Status line** — [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- 💻 **Floating terminal** — [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
- 🌿 **Git integration** — [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) + LazyGit via [snacks.nvim](https://github.com/folke/snacks.nvim)
- 🔗 **Auto pairs & commenting** — [nvim-autopairs](https://github.com/windwp/nvim-autopairs), [Comment.nvim](https://github.com/numToStr/Comment.nvim)
- 📁 **File explorer** — [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)
- 🍿 **Extras** — [snacks.nvim](https://github.com/folke/snacks.nvim) (dashboard, big-file handling, animations, word highlighting, quick file loading)

## 📦 Requirements

- [Neovim](https://neovim.io/) >= 0.10 (some features check for `nvim-0.10`)
- [Git](https://git-scm.com/) (for `lazy.nvim` bootstrap and plugin installs)
- A [Nerd Font](https://www.nerdfonts.com/) for icons (used by lualine, nvim-tree, telescope, etc.)
- [ripgrep](https://github.com/BurntSushi/ripgrep) for Telescope live grep
- [PowerShell 7 (`pwsh`)](https://github.com/PowerShell/PowerShell) — the default shell configured for toggleterm on Windows (edit the `shell` path in `lua/plugins/init.lua` if yours differs, or if you're not on Windows)
- [LazyGit](https://github.com/jesseduffield/lazygit) if you want to use the `<leader>gg` / `<leader>gf` keymaps

LSP servers and formatters (`clangd`, `omnisharp`, `lua_ls`, `pyright`, `stylua`, `csharpier`, `clang-format`, `black`) are installed automatically by `mason-tool-installer` on first launch.

## 🚀 Installation

1. Back up any existing Neovim config:
   ```powershell
   Rename-Item $env:LOCALAPPDATA\nvim nvim.bak
   ```
2. Clone this repo into your Neovim config directory:
   ```powershell
   git clone https://github.com/<your-username>/Nvim-Config-w0x7y.git $env:LOCALAPPDATA\nvim
   ```
   > Note: the config lives inside the `nvim/` subfolder of this repo. Either clone directly to `$env:LOCALAPPDATA\nvim`, or symlink/copy the `nvim/` folder there.
3. Launch Neovim:
   ```powershell
   nvim
   ```
   `lazy.nvim` will bootstrap itself and install all plugins automatically. Mason will then install the configured LSPs and formatters.

## 🗂️ Structure

```
Nvim-Config-w0x7y/
├── LICENSE
├── README.md
└── nvim/
    ├── init.lua               # Core settings, keymaps, lazy.nvim bootstrap
    ├── lazy-lock.json         # Pinned plugin versions
    └── lua/
        └── plugins/
            └── init.lua       # All plugin specs and configuration
```

## ⌨️ Key Bindings

Leader key: `<Space>`

| Keymap | Mode | Action |
| --- | --- | --- |
| `<C-c>` | Visual | Copy selection to system clipboard |
| `<C-x>` | Visual | Cut selection to system clipboard |
| `<leader>ff` | Normal | Find files (Telescope) |
| `<leader>fg` | Normal | Live grep (Telescope) |
| `<leader>fb` | Normal | List open buffers (Telescope) |
| `<leader>jf` | Normal/Visual | Format file or selection (conform.nvim) |
| `<leader>e` | Normal | Toggle file explorer (nvim-tree) |
| `<leader>gg` | Normal | Open LazyGit (floating) |
| `<leader>gf` | Normal | Open LazyGit file history |
| `` <C-\> `` | Normal/Terminal | Toggle floating terminal |
| `<Esc>` / `jk` | Terminal | Exit terminal mode |
| `<C-h/j/k/l>` | Terminal | Navigate to adjacent window |

## ⚙️ Editor Settings

- Relative + absolute line numbers
- True color support
- Mouse enabled in all modes
- System clipboard integration (`unnamedplus`)
- 4-space indentation, expand tabs, smart indent
- Case-insensitive search, smart case
- New splits open below/right
- Sign column always shown

## 🧩 Language Support

| Language | LSP | Formatter |
| --- | --- | --- |
| C/C++ | `clangd` | `clang-format` |
| C# | `omnisharp` | `csharpier` |
| Lua | `lua_ls` | `stylua` |
| Python | `pyright` | `black` |

Files are formatted automatically on save (with a 1000 ms timeout to accommodate slower formatters like C#/C++).

## 📝 License

Distributed under the [MIT License](LICENSE).
