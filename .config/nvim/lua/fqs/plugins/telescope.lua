return {
   "nvim-telescope/telescope.nvim",
   branch = "0.1.x",
   dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
   },
   config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local wk = require("which-key")

      telescope.setup({
         defaults = {
            path_display = { "truncate " },
            mappings = {
               i = {
                  ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                  ["<C-j>"] = actions.move_selection_next, -- move to next result
                  ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
               },
            },
         },
      })

      telescope.load_extension("fzf")

      -- set keymaps
      wk.register({
         p = {
            name = "Project", -- optional group name
            f = { "<cmd>Telescope find_files<cr>", "Fuzzy find files in cwd" }, -- create a binding with label
            r = { "<cmd>Telescope oldfiles<cr>", "Fuzzy find recent files" }, -- create a binding with label
            s = { "<cmd>Telescope live_grep<cr>", "Find string in cwd" }, -- create a binding with label
            b = { "<cmd>Telescope buffers<cr>", "Find Buffers" }, -- create a binding with label
            c = { "<cmd>Telescope grep_string<cr>", "Find string under cursor in cwd" }, -- create a binding with label
         },
      }, { prefix = "<leader>" }, { mode = "n" })
   end,
}
