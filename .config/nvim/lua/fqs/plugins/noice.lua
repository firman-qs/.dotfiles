-- conf from devaslive
-- https://github.com/craftzdog/dotfiles-public/blob/master/.config/nvim/lua/plugins/ui.lua
-- return {
--    "folke/noice.nvim",
--    opts = function(_, opts)
--       table.insert(opts.routes, {
--          filter = {
--             event = "notify",
--             find = "No information available",
--          },
--          opts = { skip = true },
--       })
--       local focused = true
--       vim.api.nvim_create_autocmd("FocusGained", {
--          callback = function()
--             focused = true
--          end,
--       })
--       vim.api.nvim_create_autocmd("FocusLost", {
--          callback = function()
--             focused = false
--          end,
--       })
--       table.insert(opts.routes, 1, {
--          filter = {
--             cond = function()
--                return not focused
--             end,
--          },
--          view = "notify_send",
--          opts = { stop = false },
--       })
--
--       opts.commands = {
--          all = {
--             -- options for the message history that you get with `:Noice`
--             view = "split",
--             opts = { enter = true, format = "details" },
--             filter = {},
--          },
--       }
--
--       vim.api.nvim_create_autocmd("FileType", {
--          pattern = "markdown",
--          callback = function(event)
--             vim.schedule(function()
--                require("noice.text.markdown").keys(event.buf)
--             end)
--          end,
--       })
--
--       opts.presets.lsp_doc_border = true
--    end,
-- }

return {
   "folke/noice.nvim",
   event = "VeryLazy",
   dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
   },
   config = function()
      require("noice").setup({
         routes = {
            {
               filter = { event = "notify", find = "No information available" },
               opts = { skip = true },
            },
         },
         presets = {
            -- bottom_search = true, -- use a classic bottom cmdline for search
            -- command_palette = true, -- position the cmdline and popupmenu together
            -- long_message_to_split = true, -- long messages will be sent to a split
            -- inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true, -- add a border to hover docs and signature help
         },
      })
   end,
}
--  {
--   "folke/noice.nvim",
--   event = "VeryLazy",
--   opts = {
--     routes = {
--       {
--         filter = { event = "notify", find = "No information available" },
--         opts = { skip = true },
--       },
--     },
--     presets = {
--       lsp_doc_border = true,
--     },
--   },
--   dependencies = {
--     "MunifTanjim/nui.nvim",
--     "rcarriga/nvim-notify",
--   },
-- },
