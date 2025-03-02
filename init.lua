-------------------------------------------------
-- General Settings / 一般設定
-------------------------------------------------
vim.o.number         = true              -- Enable line numbers / 行番号を有効にする
vim.o.wrap = false
vim.o.relativenumber = false              -- Enable relative numbering / 相対行番号を有効にする
vim.o.tabstop        = 4                 -- Tab width / タブ幅
vim.o.shiftwidth     = 4                 -- Indentation width / インデント幅
vim.o.expandtab      = true              -- Use spaces instead of tabs / タブの代わりにスペースを使用
vim.o.cursorline     = true              -- Highlight the current line / カーソル行をハイライトする
vim.o.termguicolors  = true              -- Enable true colors / 24bitカラーを有効にする
vim.opt.clipboard    = "unnamedplus"     -- Use system clipboard / システムクリップボードを使用
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.swapfile = false

-------------------------------------------------
-- Key Mappings / キーマッピング
-------------------------------------------------
-- Set leader key to space / Leaderキーをスペースに設定
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic keymaps / 基本的なキーマップ
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })  -- Save
vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })  -- Quit
vim.keymap.set('n', '<leader>h', ':noh<CR>', { noremap = true, silent = true })  -- Clear search highlight

-- Window navigation / ウィンドウ操作
vim.keymap.set('n', '<leader>v', ':vsplit<CR>', { noremap = true, silent = true })  -- Vertical split
vim.keymap.set('n', '<leader>s', ':split<CR>', { noremap = true, silent = true })   -- Horizontal split

-- File explorer / ファイルエクスプローラー
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { noremap = true, silent = true })

-- Terminal / ターミナル
vim.keymap.set('n', '<leader>t', ':terminal<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })  -- Terminal escape

-- Trouble / エラーリスト
vim.keymap.set('n', '<leader>xx', ':TroubleToggle<CR>', { noremap = true, silent = true })

-- Git / Gitコマンド
vim.keymap.set('n', '<leader>g', ':Neotree float git_status<CR>', { noremap = true, silent = true })

-------------------------------------------------
-- Bootstrap lazy.nvim / lazy.nvim ブートストラップ
-------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",  -- Latest stable release / 最新の安定版リリース
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------
-- Plugin Setup / プラグイン設定 (Inline Specs)
-------------------------------------------------
require("lazy").setup({
  -- Neo-tree: File Explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",  -- Use branch v2.x (check repo for details)
    dependencies = {
      "nvim-lua/plenary.nvim",           -- Utility functions
      "nvim-tree/nvim-web-devicons",      -- Optional, for file icons
      "MunifTanjim/nui.nvim",             -- UI components for Neo-tree
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            visible         = true,  -- Show filtered items / フィルタ項目を表示
            hide_dotfiles   = false, -- Show dotfiles / ドットファイルを表示
            hide_gitignored = false, -- Show git-ignored files / Git無視ファイルを表示
          },
          use_libuv_file_watcher = true,       -- Enable file watcher / ファイルウォッチャーを有効にする
          hijack_netrw_behavior  = "open_default", -- Override netrw behavior / netrwの動作を上書き
        },
        window = {
          position = "left",   -- Position on the left / 左側に配置
          width    = 30,       -- Set window width / ウィンドウ幅
        },
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function()
              vim.opt_local.signcolumn = "auto"  -- Show sign column automatically / signcolumnを自動表示
            end,
          },
        },
        enable_refresh_on_write = true,  -- Refresh on write / 書き込み時にリフレッシュ
        source_selector = {
          winbar         = true,
          content_layout = "center",
        },
      })
    end,
  },

  -- Add other plugins as needed / 必要に応じて他のプラグインを追加してください
  -- Example:
  { "nvim-tree/nvim-web-devicons" },  -- File icons
  { "nvim-lualine/lualine.nvim" },      -- Statusline
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },  -- Syntax highlighting
  { "bufferline.nvim" },                -- Buffer line

  -- Trouble for error list
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        position = "bottom",
        height = 10,
        icons = true,
    }
  },

  -- Git signs and integration
  {
    'lewis6991/gitsigns.nvim',
    config = true
  },

  -- Syntax highlighting enhancement
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "lua", "vim", "vimdoc", "javascript", "typescript", "python",
                "c", "cpp", "rust", "go", "html", "css", "json", "yaml",
                "markdown", "bash"
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
        })
    end
  },

  -- Tree-sitterプラグイン設定を更新
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "vim" },  -- 最初は最小限のパーサーから始める
            highlight = {
                enable = true,
                disable = {},
            },
            indent = { enable = true },
            auto_install = false,  -- 自動インストールを無効化
        })

        -- Windowsでのコンパイラ設定
        require("nvim-treesitter.install").compilers = { "clang", "gcc" }
        
        -- パーサーインストールディレクトリの設定
        vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/tree-sitter")
        vim.cmd([[set runtimepath+=]] .. vim.fn.stdpath("data") .. "/tree-sitter")
    end,
  },

  -- Modern colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },

  -- VSCode Dark Theme
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require('vscode').setup({
            -- Enable transparent background
            transparent = false,
            -- Enable italic comments
            italic_comments = true,
            -- Disable nvim-tree background color
            disable_nvimtree_bg = true,
            -- Override colors
            color_overrides = {
                vscLineNumber = '#505050',
            },
        })
    end
  },
  -- etc.
})

-------------------------------------------------
-- Colorscheme and Custom Highlights / カラースキームとカスタムハイライト
-------------------------------------------------
vim.o.background = 'dark'
vim.cmd('colorscheme vscode')

-- VSCode-like editor colors
vim.api.nvim_set_hl(0, 'Normal', { bg = '#000000', fg = '#D4D4D4' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#000000' })
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#505050' })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#1A1A1A' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#C6C6C6' })
vim.api.nvim_set_hl(0, 'Visual', { bg = '#264F78' })

-- Syntax highlighting colors
vim.api.nvim_set_hl(0, '@variable', { fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, '@function', { fg = '#DCDCAA' })
vim.api.nvim_set_hl(0, '@keyword', { fg = '#C586C0' })
vim.api.nvim_set_hl(0, '@string', { fg = '#CE9178' })
vim.api.nvim_set_hl(0, '@number', { fg = '#B5CEA8' })
vim.api.nvim_set_hl(0, '@comment', { fg = '#6A9955', italic = true })
vim.api.nvim_set_hl(0, '@type', { fg = '#4EC9B0' })
vim.api.nvim_set_hl(0, '@constructor', { fg = '#4EC9B0' })
vim.api.nvim_set_hl(0, '@parameter', { fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, '@field', { fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, '@property', { fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, '@punctuation', { fg = '#D4D4D4' })

-- Update Lualine theme
require('lualine').setup({
    options = {
        theme = 'vscode',
        icons_enabled        = true,
        component_separators = { left = '', right = '' },
        section_separators   = { left = '', right = '' },
        globalstatus         = false,
        refresh = {
            statusline = 1000,
            tabline    = 1000,
            winbar     = 1000,
        },
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
})

-------------------------------------------------
-- Function Definitions / 関数定義
-------------------------------------------------
-- Function to open Neo-tree after startup / 起動後にNeo-treeを開く関数
local function open_neotree()
    vim.schedule(function()
        local ok, _ = pcall(require("neo-tree.command").execute, { action = "show" })
        if not ok then
            print("Failed to open NeoTree.")  -- NeoTreeの起動に失敗しました
        end
    end)
end

-- レイアウト管理関数を更新
local function setup_workspace_layout()
    -- 左側のエクスプローラー (既存の Neo-tree)
    vim.cmd("Neotree show")
    
    -- 右側の分割を作成
    vim.cmd("vsplit")
    vim.cmd("wincmd L")

    -- 右下にターミナルを開く
    local cwd = vim.loop.cwd()
    vim.cmd("terminal powershell -NoExit -Command 'cd \"" .. cwd .. "\"'")  -- Open terminal in current directory / 現在のディレクトリでターミナルを開く
    vim.cmd("split")
    vim.cmd("terminal powershell -NoExit -Command 'cd \"" .. cwd .. "\"'")  -- Open terminal in current directory / 現在のディレクトリでターミナルを開く

    -- エラー一覧を開く
    vim.cmd("Trouble")

    -- 左下に Git 状態を表示
    vim.cmd("wincmd h")
    vim.cmd("vsplit")
    vim.cmd("wincmd j")
    require('gitsigns').setup()

    -- メインエディタに戻る
    vim.cmd("wincmd h")
end

-------------------------------------------------
-- Autocommands for Auto-Opening Panels / パネル自動オープンのオートコマンド
-------------------------------------------------

-- 起動時の自動実行を更新
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function()
        vim.schedule(function()
            open_neotree()
            setup_workspace_layout()
        end)
    end,
})

-------------------------------------------------
-- Devicons Setup / ファイルアイコン設定
-------------------------------------------------
require('nvim-web-devicons').setup({
    color_icons = true,
    default     = true,
})

-------------------------------------------------
-- Treesitter Setup / Treesitter 設定
-------------------------------------------------
require('nvim-treesitter.configs').setup({
    highlight = { enable = true },
})

-------------------------------------------------
-- Telescope Keybindings / Telescope キーバインディング
-------------------------------------------------
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', { noremap = true, silent = true })

-------------------------------------------------
-- Bufferline Setup / Bufferline 設定
-------------------------------------------------
require("bufferline").setup({})

-------------------------------------------------
-- End of Configuration / 設定の終わり
-------------------------------------------------
