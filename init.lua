vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.cursorline = true
vim.o.termguicolors = true
vim.opt.clipboard = 'unnamedplus'


-- bootstrap lazy.nvim, LazyVim and your plugins

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {})


-- vim.cmd('colorscheme codedark')
vim.cmd('colorscheme industry')


-- Neotreeを自動で開くための関数
local function open_neotree()
    -- `vim.schedule`を使って、Neovimの起動後に遅延実行します
    vim.schedule(function()
        -- `require("neo-tree.command").execute`を使って、Neotreeを開きます
        local ok, _ = pcall(require("neo-tree.command").execute, { action = "show" })
        if not ok then
            print("Failed to open NeoTree.")
        end
    end)
end

-- ターミナルを自動で開くための関数
local function open_terminal_right()
    print("現在のディレクトリ:", vim.fn.getcwd())
    vim.api.nvim_command('vnew')
    vim.api.nvim_command('wincmd L')
    vim.api.nvim_command('vnew')
    vim.api.nvim_command("terminal powershell -NoExit -Command 'cd \"" .. vim.loop.cwd() .. "\"'")
    vim.api.nvim_command('wincmd L')
end


vim.api.nvim_create_autocmd("VimEnter", {
    callback = open_neotree,
})
vim.api.nvim_create_autocmd("VimEnter", {
    callback = open_terminal_right,
})

vim.api.nvim_create_autocmd("TabNew", {
    callback = open_neotree,
})
vim.api.nvim_create_autocmd("TabNew", {
    callback = open_terminal_right,
})


-- Neotree
neotree = require('neo-tree')
neotree.setup({
    filesystem = {
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
        },
        -- follow_current_file = true,
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_default",
        -- hijack_netrw_behavior = "open_current",
    },
    buffers = {
        -- follow_current_file = true,
        -- pin_on_open = true,  -- 開いたファイルをピン止めする
    },
    window = {
        position = "left",
        width = 30,
    },
    event_handlers = {
    {
        event = "neo_tree_buffer_enter",
        handler = function()
        vim.opt_local.signcolumn = "auto"
        end,
    },
    },
    enable_refresh_on_write = true,
    source_selector = {
        winbar = true,
        content_layout = "center",
    },
})
vim.api.nvim_command(':Neotree dir='..vim.fn.getcwd())

-- ファイルアイコン
require'nvim-web-devicons'.setup {
    color_icons = true;
    default = true;
}



-- status

-- vim.g.airline_theme = 'codedark'
-- vim.g.airline_section_a = '%t'
-- vim.g.airline_section_c = '%t %y'
-- vim.g.airline_powerline_fonts = 1
-- vim.g['airline#extensions#mode#enabled'] = 1
-- vim.o.laststatus = 1
-- vim.o.showtabline = 2
-- vim.o.tabline = '%t'
-- vim.g['airline#extensions#tabline#enabled'] = 1

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'codedark',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
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
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

-- シンタックス
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    }
}


-- hex editor
-- require('hex').setup{
--     auto_open = false
-- }


-- telescope
vim.api.nvim_set_keymap('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', {noremap = true, silent = true})


-- bufferline
vim.opt.termguicolors = true
require("bufferline").setup{}



-- カラーテーマ
vim.cmd('highlight Normal guibg=#000000')
vim.cmd('highlight LineNr guifg=#505050')
vim.cmd('highlight CursorLine guibg=#101010')

vim.cmd('highlight Comment guifg=#305030')
vim.cmd('highlight String guifg=#ce6f27')
vim.cmd('highlight Special guifg=#005000')