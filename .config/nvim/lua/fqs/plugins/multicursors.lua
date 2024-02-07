return {
   "mg979/vim-visual-multi",
   init = function()
      vim.g.VM_maps = {
         ["Find Under"] = "<A-d>",
         ["Find Subword Under"] = "<A-d>",
      }
   end,
   config = function()
      local wk = require("which-key")
      wk.register({
         {
            m = {
               name = "Format/Multi Cursors", -- optional group name
               ca = { "<Plug>(VM-Visual-All)", "Multi cursors visual all" }, -- create a binding with label
            },
         },
         prefix = "<leader>",
         mode = "v",
      })
      vim.keymap.set("n", "<A-LeftMouse>", "<Plug>(VM-Mouse-Cursor)")
   end,
}
