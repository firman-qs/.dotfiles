return {
   "nvim-lualine/lualine.nvim",
   dependencies = { "nvim-tree/nvim-web-devicons" },
   config = function()
      local colors = {
         insertbg = "#7a7d55",
         visualbg = "#57557d",
         commndbg = "#5e7d55",
         inactivebg = "#222222",
         replacebg = "#7d5555",
         normbg = "#00000000",
         normfg = "#ce9178",
         fg = "#000000",
         bg = "#576169",
         accentbg = "#576169",
         accentfg = "#000000",
      }

      local my_lualine_theme = {
         normal = {
            a = { bg = colors.normbg, fg = colors.normfg, gui = "bold" },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
            z = { bg = colors.bg, fg = colors.fg },
         },
         insert = {
            a = { bg = colors.insertbg, fg = colors.accentfg, gui = "bold" },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
            z = { bg = colors.bg, fg = colors.fg },
         },
         visual = {
            a = { bg = colors.visualbg, fg = colors.fg, gui = "bold" },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
            z = { bg = colors.bg, fg = colors.fg },
         },
         command = {
            a = { bg = colors.commndbg, fg = colors.fg, gui = "bold" },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
            z = { bg = colors.bg, fg = colors.fg },
         },
         replace = {
            a = { bg = colors.replacebg, fg = colors.fg, gui = "bold" },
            b = { bg = colors.bg, fg = colors.fg },
            c = { bg = colors.bg, fg = colors.fg },
         },
         inactive = {
            a = { bg = colors.inactivebg, fg = colors.semilightgray, gui = "bold" },
            b = { bg = colors.inactivebg, fg = colors.semilightgray },
            c = { bg = colors.inactivebg, fg = colors.semilightgray },
         },
      }

      require("lualine").setup({
         options = {
            theme = my_lualine_theme,
            component_separators = { left = "|", right = "|" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = {
               statusline = {},
               winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
               statusline = 1000,
               tabline = 1000,
               winbar = 1000,
            },
         },
         sections = {
            lualine_a = {
               {
                  "mode",
                  fmt = function(str)
                     return "[ " .. str:sub(1, 3) .. " ]"
                  end,
               },
            },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { "filename" },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
         },
         inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
         },
         tabline = {},
         winbar = {},
         inactive_winbar = {},
         extensions = {},
      })
   end,
}
