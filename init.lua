-------------------------------------------------
-- エディタの基本設定
-------------------------------------------------
-- 行の位置を把握しやすくする
vim.o.number = true
vim.o.relativenumber = false
-- 長い行を折り返さない（横スクロールで表示）
vim.o.wrap = false
-- インデントの設定（4スペースをタブとして扱う）
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
-- カーソル位置を見やすくする
vim.o.cursorline = true
-- モダンな配色を可能にする, 24bits color
vim.o.termguicolors = true
-- OSのクリップボードと連携
vim.opt.clipboard = "unnamedplus"
-- 文字化けを防ぐ
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
-- 作業中のファイルを保護しない（git等で管理することを前提）
vim.opt.swapfile = false

-------------------------------------------------
-- キーマッピング（ショートカット）の設定
-------------------------------------------------
-- Spaceキーをショートカットの起点にする
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 基本的な操作のショートカット
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })  -- 作業内容を保存
vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })  -- エディタを閉じる
vim.keymap.set('n', '<leader>h', ':noh<CR>', { noremap = true, silent = true })  -- 検索結果のハイライトを消す

-- 画面分割の操作
vim.keymap.set('n', '<leader>v', ':vsplit<CR>', { noremap = true, silent = true })  -- 画面を左右に分割
vim.keymap.set('n', '<leader>s', ':split<CR>', { noremap = true, silent = true })   -- 画面を上下に分割

-- ファイルツリーの表示切替
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { noremap = true, silent = true })

-- ターミナル操作
vim.keymap.set('n', '<leader>t', ':terminal<CR>', { noremap = true, silent = true })  -- ターミナルを開く
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })  -- ターミナルから抜ける

-- 問題の一覧表示
vim.keymap.set('n', '<leader>xx', ':TroubleToggle<CR>', { noremap = true, silent = true })

-- Gitの状態確認
vim.keymap.set('n', '<leader>g', ':Neotree float git_status<CR>', { noremap = true, silent = true })

-------------------------------------------------
-- プラグインマネージャーの設定
-------------------------------------------------
-- lazy.nvimが存在しない場合はインストール
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",  -- 安定版を使用
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------
-- Plugin Setup / プラグイン設定 (Inline Specs)
-------------------------------------------------
require("lazy").setup({ -- Neo-tree: File Explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x", -- Use branch v2.x (check repo for details)
        dependencies = {
            "nvim-lua/plenary.nvim", -- Utility functions
            "nvim-tree/nvim-web-devicons", -- Optional, for file icons
            "MunifTanjim/nui.nvim", -- UI components for Neo-tree
        },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    filtered_items = {
                        visible = true, -- Show filtered items / フィルタ項目を表示
                        hide_dotfiles = false, -- Show dotfiles / ドットファイルを表示
                        hide_gitignored = false -- Show git-ignored files / Git無視ファイルを表示
                    },
                    use_libuv_file_watcher = true, -- Enable file watcher / ファイルウォッチャーを有効にする
                    hijack_netrw_behavior = "open_default", -- Override netrw behavior / netrwの動作を上書き
                },
                window = {
                    position = "left", -- Position on the left / 左側に配置
                    width = 30, -- Set window width / ウィンドウ幅
                },
                event_handlers = {{
                    event = "neo_tree_buffer_enter",
                    handler = function()
                        vim.opt_local.signcolumn = "auto" -- Show sign column automatically / signcolumnを自動表示
                    end
                }},
                enable_refresh_on_write = true, -- Refresh on write / 書き込み時にリフレッシュ
                source_selector = {
                    winbar = true,
                    content_layout = "center",
                }
            })
        end
    }, -- Add other plugins as needed / 必要に応じて他のプラグインを追加してください
    -- Example:
    {"nvim-tree/nvim-web-devicons"}, -- File icons
    {"nvim-lualine/lualine.nvim"}, -- Statusline
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    }, -- Syntax highlighting
    {"bufferline.nvim"}, -- Buffer line
    -- Trouble for error list
    {
        "folke/trouble.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        opts = {
            position = "bottom",
            height = 10,
            icons = true,
        }
    }, -- Git signs and integration
    {
        'lewis6991/gitsigns.nvim',
        config = true,
    }, -- Syntax highlighting enhancement
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {"lua", "vim", "vimdoc", "javascript", "typescript", "python", "c", "cpp", "rust", "go", "html", "css", "json", "yaml", "markdown", "bash"},
                highlight = { enable = true },
                indent = { enable = true }
            })
            -- Windowsでのコンパイラ設定
            require("nvim-treesitter.install").compilers = { "clang", "gcc" }

            -- パーサーインストールディレクトリの設定
            vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/tree-sitter")
            vim.cmd([[set runtimepath+=]] .. vim.fn.stdpath("data") .. "/tree-sitter")
        end
    }, -- Modern colorscheme
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
    }, -- VSCode Dark Theme
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
                color_overrides = { vscLineNumber = '#505050' }
            })
        end
    }, -- LSP Support
    {
        'neovim/nvim-lspconfig',
        dependencies = {'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim', 'saghen/blink.cmp'},
        config = function()
            -- Mason setup
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",       -- Lua
                    "pyright",      -- Python
                    "ts_ls",        -- TypeScript/JavaScript
                    "rust_analyzer",-- Rust
                    "cssls",        -- CSS
                    "html"          -- HTML
                },
                automatic_installation = true,
            })

            -- LSP servers setup
            local lspconfig = require('lspconfig')
            local servers = {'lua_ls', 'pyright', 'ts_ls', 'rust_analyzer', 'cssls', 'html'}
            for _, lsp in ipairs(servers) do
                if lsp == 'ts_ls' then
                    -- TypeScript LSP specific settings
                    lspconfig[lsp].setup({
                        filetypes = {"typescript", "javascript", "javascriptreact", "typescriptreact"},
                        root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
                    })
                elseif lsp == 'rust_analyzer' then
                    -- Rust LSP specific settings
                    lspconfig[lsp].setup({
                        settings = {
                            ["rust-analyzer"] = {
                                cargo = {
                                    allFeatures = true,  -- Enable all cargo features
                                },
                                checkOnSave = {
                                    command = "clippy"   -- Run Clippy when saving files
                                },
                                procMacro = {
                                    enable = true        -- Enable procedural macros
                                },
                            }
                        }
                    })
                else
                    lspconfig[lsp].setup {}
                end
            end

            -- Diagnostic configuration
            vim.diagnostic.config({
                virtual_text = false,
                signs = true,
                underline = true,
                update_in_insert = true,
                severity_sort = true
            })

            local capabilities = require('blink.cmp').get_lsp_capabilities()
            local lspconfig = require('lspconfig')
            lspconfig['lua_ls'].setup({ capabilities = capabilities })
        end
    }, -- LSPSaga for enhanced LSP UI
    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        dependencies = {"nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons", "neovim/nvim-lspconfig"},
        config = function()
            require("lspsaga").setup({
                ui = { border = "rounded" },
                lightbulb = { enable = false },
                symbol_in_winbar = { enable = false },
            })

            -- LSPSaga用のキーマップ
            local keymap = vim.keymap.set
            keymap('n', 'gd', '<cmd>Lspsaga peek_definition<CR>', { desc = 'Peek Definition' })
            keymap('n', 'gD', '<cmd>Lspsaga goto_definition<CR>', { desc = 'Goto Definition' })
            keymap('n', 'gr', '<cmd>Lspsaga finder<CR>', { desc = 'Find References' })
            keymap('n', 'gh', '<cmd>Lspsaga hover_doc<CR>', { desc = 'Hover Documentation' })
            keymap('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', { desc = 'Code Action' })
            keymap('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', { desc = 'Rename' })
            keymap('n', '<leader>cd', '<cmd>Lspsaga show_line_diagnostics<CR>', { desc = 'Line Diagnostics' })
            keymap('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { desc = 'Previous Diagnostic' })
            keymap('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', { desc = 'Next Diagnostic' })
            keymap('n', '<leader>o', '<cmd>Lspsaga outline<CR>', { desc = 'Show Outline' })
        end
    }, -- Auto-save configuration
    {
        "pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup({
                enabled = true,
                -- 保存のトリガー条件
                trigger_events = {
                    "InsertLeave", -- インサートモードを抜けたとき
                    "TextChanged", -- テキストが変更されたとき
                    "TextChangedI", -- インサートモード中にテキストが変更されたとき
                    "TextChangedP", -- 補完時にテキストが変更されたとき
                    "CursorMoved", -- カーソルが移動したとき
                    "CursorMovedI", -- インサートモード中にカーソルが移動したとき
                },
                -- debounce_delayを短くして即時保存に近づける
                debounce_delay = 50,
                -- 保存条件
                condition = function(buf)
                    local fn = vim.fn
                    local utils = require("auto-save.utils.data")

                    if fn.getbufvar(buf, "&modifiable") == 1 and
                        utils.not_in(fn.getbufvar(buf, "&filetype"), {"neo-tree", "lua.plugin", "terminal"}) then
                        return true
                    end
                    return false
                end,
                -- 実行前の処理
                execution_message = {
                    message = function()
                        return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
                    end,
                    dim = 0.18,
                    cleaning_interval = 1250,
                },
                -- 保存時のアニメーション
                write_all_buffers = false,
                -- キーマップ
                debounce_delay = 135,
                callbacks = {
                    enabling = nil,
                    disabling = nil,
                    before_asserting_save = nil,
                    before_saving = nil,
                    after_saving = nil,
                }
            })
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = function()
            require("ibl").setup()
        end
    },
    { -- https://cmp.saghen.dev/installation
        'saghen/blink.cmp',
        dependencies = 'rafamadriz/friendly-snippets',
        version = '*',
        opts = {
            keymap = { preset = 'default' },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    }
})

-- indent-blankline

local highlight = {"Whitespace", "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange", "RainbowGreen", "RainbowViolet", "RainbowCyan"}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#804C25" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#75703B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#417FAF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#B19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

vim.g.rainbow_delimiters = { highlight = highlight }
require("ibl").setup {
    indent = {
        highlight = highlight,
        char = ".",
    },
    whitespace = {
        highlight = highlight,
        remove_blankline_trail = false,
    },
    scope = {
        highlight = highlight,
    }
}

-------------------------------------------------
-- エディタの見た目の設定
-------------------------------------------------
-- ダークモードをベースにする
vim.o.background = 'dark'
-- VSCodeライクな見た目に設定
vim.cmd('colorscheme vscode')

-- エディタ全体の配色
vim.api.nvim_set_hl(0, 'Normal', { bg = '#000000', fg = '#D4D4D4' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#000000' })
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#505050' })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#1A1A1A' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#C6C6C6' })
vim.api.nvim_set_hl(0, 'Visual', { bg = '#264F78' })

-- コードの要素ごとの配色
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
        icons_enabled = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {{ 'filename', path = 1 }},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'},
    }
})

-------------------------------------------------
-- Function Definitions / 関数定義
-------------------------------------------------
-- Function to open Neo-tree after startup / 起動後にNeo-treeを開く関数
local function open_neotree()
    vim.schedule(function()
        local ok, _ = pcall(require("neo-tree.command").execute, {
            action = "show",
        })
        if not ok then
            print("Failed to open NeoTree.") -- NeoTreeの起動に失敗しました
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
    vim.cmd("terminal powershell -NoExit -Command 'cd \"" .. cwd .. "\"'") -- Open terminal in current directory / 現在のディレクトリでターミナルを開く
    vim.cmd("split")
    vim.cmd("terminal powershell -NoExit -Command 'cd \"" .. cwd .. "\"'") -- Open terminal in current directory / 現在のディレクトリでターミナルを開く

    -- エラー一覧を開く
    -- vim.cmd("Trouble")

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
vim.api.nvim_create_autocmd({"VimEnter"}, {
    callback = function()
        vim.schedule(function()
            open_neotree()
            setup_workspace_layout()
        end)
    end
})

-------------------------------------------------
-- Devicons Setup / ファイルアイコン設定
-------------------------------------------------
require('nvim-web-devicons').setup({
    color_icons = true,
    default = true,
})

-------------------------------------------------
-- Treesitter Setup / Treesitter 設定
-------------------------------------------------
require('nvim-treesitter.configs').setup({
    highlight = { enable = true }
})

-------------------------------------------------
-- Telescope Keybindings / Telescope キーバインディング
-------------------------------------------------
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', {
    noremap = true,
    silent = true,
})

-------------------------------------------------
-- Bufferline Setup / Bufferline 設定
-------------------------------------------------
require("bufferline").setup({})