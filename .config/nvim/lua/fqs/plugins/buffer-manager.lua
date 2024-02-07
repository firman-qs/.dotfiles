return {
   "j-morano/buffer_manager.nvim",
   event = { "BufReadPre", "BufNewFile" },
   dependencies = {
      "nvim-lua/plenary.nvim",
   },
   config = function()
      local wk = require("which-key")
      local bmui = require("buffer_manager.ui")
      local keys = "1234567890"
      require("buffer_manager").setup({
         -- some config
         line_keys = "1234567890",
         select_menu_item_commands = {
            edit = {
               key = "<CR>",
               command = "edit",
            },
            v = {
               key = "<C-v>",
               command = "vsplit",
            },
            h = {
               key = "<C-h>",
               command = "split",
            },
         },
         focus_alternate_buffer = false,
         short_file_names = false,
         short_term_names = false,
         loop_nav = true,
         highlight = "",
         win_extra_options = {},
         borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      })
      wk.register({
         b = {
            name = "buffer", -- optional group name
            i = { bmui.toggle_quick_menu, "Buffer List" },
            s = {
               function()
                  bmui.toggle_quick_menu()
                  -- wait for the menu to open
                  vim.defer_fn(function()
                     vim.fn.feedkeys("/")
                  end, 50)
               end,
               "Buffer List with Search",
            },
            n = {
               bmui.nav_next,
               "go to next buffer",
            },
            p = {
               bmui.nav_prev,
               "go to previous buffer",
            },
            k = {
               "<cmd>q<cr>",
               "kill buffer",
            },
         },
      }, { prefix = "<leader>" }, { mode = "n" })
      local switchtobuffx = {}
      for i = 1, #keys do
         local key = keys:sub(i, i)
         switchtobuffx[key] = {
            function()
               bmui.nav_file(tonumber(key))
               print("hello buffer-" .. key)
            end,
            "switch to buffer-" .. key,
         }
      end
      wk.register(switchtobuffx, { prefix = "<leader>" }, { mode = "n" })
      vim.keymap.set("n", "<C-j>", bmui.nav_next, { desc = "Next buffer" })
      vim.keymap.set("n", "<C-k>", bmui.nav_prev, { desc = "Next buffer" })
   end,
}
