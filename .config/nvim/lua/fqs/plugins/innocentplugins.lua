return {
   "christoomey/vim-tmux-navigator",
   cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
   },
   keys = {
      { "<leader>wh", "<cmd>TmuxNavigateLeft<cr>", { desc = "Window Left" } },
      { "<leader>wj", "<cmd>TmuxNavigateDown<cr>", { desc = "Window Down" } },
      { "<leader>wk", "<cmd>TmuxNavigateUp<cr>", { desc = "WIndow Up" } },
      { "<leader>wl", "<cmd>TmuxNavigateRight<cr>", { desc = "Window Right" } },
      { "<leader>ww", "<cmd>TmuxNavigatePrevious<cr>", { desc = "Window Previous" } },
   },
}
