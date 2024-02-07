return {
   "rmagatti/auto-session",
   config = function()
      require("auto-session").setup({
         auto_restore_enabled = false,
         auto_session_suppress_dirs = { "~/", "~/starship/", "~/Downloads", "~/Documents", "~/Desktop/" },
      })
   end,
}
