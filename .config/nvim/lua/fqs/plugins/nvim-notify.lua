return {
   "rcarriga/nvim-notify",
   config = function()
      require("notify").setup({
         timeout = 1000,
         render = "wrapped-compact",
         stages = "fade",
         maximum_width = 50,
         top_down = true,
      })
   end,
}
