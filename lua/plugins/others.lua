return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            "3rd/image.nvim",
        }
    },
    {
        "nvim-tree/nvim-web-devicons"
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        "tomasiser/vim-code-dark" -- カラーテーマ
    },
    {
        "simeji/winresizer" -- リサイザ
    },
    {
        "nvim-treesitter/nvim-treesitter", -- シンタックス
        run = ":TSUpdate",  -- インストール後にParserを自動で更新
        opts = {
            ensure_installed = { "lua", "toml", "bash", "c", "c_sharp", "rust", "json", "html", "python", "javascript" },  -- 対応させたい言語
            highlight = {
                enable = true,  -- シンタックスハイライトを有効化
            },
            indent = {
                enable = true,  -- インデントを有効化
            },
        },
    },
    { 'RaafatTurki/hex.nvim' }, -- hex editor
    {
        'nvim-telescope/telescope.nvim',
    },
    { -- タブページ
        'akinsho/bufferline.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons'
    }
}