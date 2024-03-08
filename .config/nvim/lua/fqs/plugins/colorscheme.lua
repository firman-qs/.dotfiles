return {
   "olimorris/onedarkpro.nvim",
   priority = 1000, -- Ensure it loads first
   config = function()
      require("onedarkpro").setup({
         options = {
            transparency = true,
         },
      })
      vim.cmd([[colorscheme onedark]])
   end,
}

-- return {
--    "ellisonleao/gruvbox.nvim",
--    priority = 1000, -- Ensure it loads first
--    config = function()
--       vim.cmd([[colorscheme gruvbox]])
--    end,
-- }

-- return {
--    "sainnhe/gruvbox-material",
--    lazy = false,
--    priority = 1000,
--    config = function()
--       -- require("gruvbox-material").setup({})
--       vim.cmd([[colorscheme gruvbox-material]])
--    end,
-- }
-- return {
--    "Mofiqul/vscode.nvim",
--    lazy = false,
--    priority = 1000,
--    config = function()
--       require("vscode").setup({
--          italic_comments = true,
--       })
--       vim.cmd([[colorscheme vscode]])
--    end,
-- }

-- return {
--    "thimc/gruber-darker.nvim",
--    version = false,
--    lazy = false,
--    priority = 1000, -- make sure to load this before all the other start plugins
--    -- Optional; default configuration will be used if setup isn't called.
--    config = function()
--       require("gruber-darker").setup({
--          -- Your config here
--          transparent = true, -- removes the background
--       })
--       vim.cmd([[colorscheme gruber-darker]])
--    end,
-- }

-- return {
--    "rebelot/kanagawa.nvim",
--    version = false,
--    lazy = false,
--    priorty = 999,
--    config = function()
--       require("kanagawa").setup({
--          compile = false, -- enable compiling the colorscheme
--          undercurl = true, -- enable undercurls
--          commentStyle = { italic = true },
--          functionStyle = {},
--          keywordStyle = { italic = true },
--          statementStyle = { bold = true },
--          typeStyle = {},
--          transparent = false, -- do not set background color
--          dimInactive = false, -- dim inactive window `:h hl-NormalNC`
--          terminalColors = true, -- define vim.g.terminal_color_{0,17}
--          colors = { -- add/modify theme and palette colors
--             palette = {},
--             theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
--          },
--          overrides = function(colors) -- add/modify highlights
--             return {}
--          end,
--          theme = "wave", -- Load "wave" theme when 'background' option is not set
--          background = { -- map the value of 'background' option to a theme
--             dark = "wave", -- try "dragon" !
--             light = "lotus",
--          },
--       })
--       vim.cmd("colorscheme kanagawa")
--    end,
-- }
