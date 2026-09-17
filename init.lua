-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
    	{
  	"navarasu/onedark.nvim",
  	priority = 9999, -- make sure to load this before all the other start plugins
  	config = function()
    	require('onedark').setup {
      		style = 'cool'
    	}
    	require('onedark').load()
  	end
	},
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
  end,	},
  {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    icons   = { mappings = false, breadcrumb = "", separator = " ", group = "" },

    replace = {
      key  = { function(k) return k end },
      desc = { },
    },

    filter  = function(m) return m.desc and m.desc ~= "" end,

    plugins = {
      marks=false, registers=false, spelling={enabled=false},
      presets = { operators=false, motions=false, text_objects=false,
                  windows=false, nav=false, z=false, g=false },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}

  },
  
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "onedark" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

vim.diagnostic.config({
  virtual_text = {
    prefix = '●', -- 诊断信息前的符号，可自定义
    source = 'if_many', -- 当存在多个诊断来源时显示来源
    severity = {
      min = vim.diagnostic.severity.WARN -- 只显示警告及以上级别
    },
  }})

vim.lsp.config["hls"] = {
  cmd = { "haskell-language-server-wrapper", "--lsp" },
  filetypes = { "haskell" },
  root_markers = {
    "hie.yaml",
    "stack.yaml",
    "cabal.project",
    "*.cabal",
    "package.yaml",
    ".git",
  },
}
vim.lsp.enable("hls")
