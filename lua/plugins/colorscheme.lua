-- Using Lazy
return {
{
  "navarasu/onedark.nvim",
  priority = 9999, -- make sure to load this before all the other start plugins
  config = function()
    require('onedark').setup {
      style = 'cool'
    }
    require('onedark').load()
  end
}
}
