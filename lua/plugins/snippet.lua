-- プラグイン設定（例: lazy.nvimを使用）
return {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",  -- LSPサーバーからの補完
      "hrsh7th/cmp-buffer",    -- バッファ内の単語からの補完
      "hrsh7th/cmp-path",      -- ファイルパスの補完
      "hrsh7th/cmp-cmdline",   -- コマンドラインの補完
      "L3MON4D3/LuaSnip",      -- スニペット補完
      "saadparwaiz1/cmp_luasnip", -- スニペット補完との連携
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- LuaSnipを使ったスニペットの展開
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item(),  -- 次の補完候補を選択
          ['<C-p>'] = cmp.mapping.select_prev_item(),  -- 前の補完候補を選択
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Enterで補完を確定
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },  -- LSPからの補完
          { name = "luasnip" },   -- スニペットの補完
          { name = "buffer" },    -- バッファ内の補完
          { name = "path" },      -- パスの補完
        }),
      })
    end
  }