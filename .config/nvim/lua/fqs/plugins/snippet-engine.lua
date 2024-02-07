return {
   "L3MON4D3/LuaSnip",
   build = "make install_jsregexp",
   config = function()
      require("luasnip").setup({
         update_events = "TextChanged,TextChangedI",
         store_selection_keys = "<Tab>",
      })
   end,
}
