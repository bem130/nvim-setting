-------------------------------------------------
-- General Settings / 一般設定
-------------------------------------------------
vim.o.number         = true              -- Enable line numbers / 行番号を有効にする
vim.o.relativenumber = true              -- Enable relative numbering / 相対行番号を有効にする
vim.o.tabstop        = 4                 -- Tab width / タブ幅
vim.o.shiftwidth     = 4                 -- Indentation width / インデント幅
vim.o.expandtab      = true              -- Use spaces instead of tabs / タブの代わりにスペースを使用
vim.o.cursorline     = true              -- Highlight the current line / カーソル行をハイライトする
vim.o.termguicolors  = true              -- Enable true colors / 24bitカラーを有効にする
vim.opt.clipboard    = "unnamedplus"     -- Use system clipboard / システムクリップボードを使用

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
  -- etc.
})

-------------------------------------------------
-- Colorscheme and Custom Highlights / カラースキームとカスタムハイライト
-------------------------------------------------
-- Choose your colorscheme
-- お好みのカラースキームを選んでください
vim.cmd('colorscheme industry')

-- Custom highlights for a strict dark theme / 厳格なダークテーマ用のカスタムハイライト
vim.cmd('highlight Normal     guibg=#000000')
vim.cmd('highlight LineNr     guifg=#505050')
vim.cmd('highlight CursorLine guibg=#101010')
vim.cmd('highlight Comment    guifg=#305030')
vim.cmd('highlight String     guifg=#ce6f27')
vim.cmd('highlight Special    guifg=#005000')

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

-- Function to open a terminal on the right side / 右側にターミナルを開く関数
local function open_terminal_right()
    local cwd = vim.loop.cwd()
    print("Current Directory: " .. cwd)  -- 現在のディレクトリを表示
    vim.cmd("vsplit")                   -- Create a vertical split / 垂直分割を作成
    vim.cmd("wincmd L")                 -- Move window to far right / ウィンドウを右端へ移動
    vim.cmd("split")                    -- Create a horizontal split / 水平分割を作成
    vim.cmd("terminal powershell -NoExit -Command 'cd \"" .. cwd .. "\"'")  -- Open terminal in current directory / 現在のディレクトリでターミナルを開く
    vim.cmd("wincmd L")                 -- Adjust focus if needed / 必要ならフォーカスを調整
end

-------------------------------------------------
-- Autocommands for Auto-Opening Panels / パネル自動オープンのオートコマンド
-------------------------------------------------
vim.api.nvim_create_autocmd({ "VimEnter", "TabNew" }, {
    callback = function()
        open_neotree()
        open_terminal_right()
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
-- Lualine (Statusline) Setup / Lualine ステータスラインの設定
-------------------------------------------------
require('lualine').setup({
    options = {
        icons_enabled        = true,
        theme                = 'codedark',
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
