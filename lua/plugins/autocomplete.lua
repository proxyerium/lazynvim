return {
	{
		"hrsh7th/nvim-cmp",
		priority = 100,
		dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- LSP 补全源
    "hrsh7th/cmp-buffer",   -- 缓冲区补全源
    "hrsh7th/cmp-path",     -- 路径补全源
    "hrsh7th/cmp-cmdline",  -- 命令行补全源
    "L3MON4D3/LuaSnip",     -- 代码片段引擎
    "saadparwaiz1/cmp_luasnip", -- LuaSnip 补全源
    "rafamadriz/friendly-snippets", -- 预定义代码片段
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), 
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- LSP 补全
        { name = "luasnip" },  -- 代码片段补全
        { name = "buffer" },   -- 缓冲区补全
        { name = "path" },     -- 路径补全
      }),
    })

    -- 为命令行模式启用补全
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline" },
      }),
    })
  end,	}
}
