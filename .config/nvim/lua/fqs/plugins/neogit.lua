return {
   "NeogitOrg/neogit",
   dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
   },
   -- config = true,
   config = function()
      require("neogit").setup({
         vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Open Neogit" }),
      })
   end,
}
