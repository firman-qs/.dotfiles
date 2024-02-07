local function my_on_attach(bufnr)
   local api = require("nvim-tree.api")

   local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
   end

   -- open as vsplit on current node
   local function vsplit_preview()
      local node = api.tree.get_node_under_cursor()

      if node.nodes ~= nil then
         api.node.open.edit()
      else
         api.node.open.vertical()
      end

      api.tree.focus()
   end

   -- default mappings
   api.config.mappings.default_on_attach(bufnr)

   -- custom mappings
   vim.keymap.set("n", "l", api.node.open.preview, opts("Edit Or Open"))
   vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
   vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close"))
   vim.keymap.set("n", "<Esc>", api.tree.close, opts("Close"))
   vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
   vim.keymap.set("n", "<leader>h", api.tree.toggle_help, opts("Help"))
end

local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.6

vim.o.confirm = true
vim.api.nvim_create_autocmd("BufEnter", {
   group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
   callback = function()
      local layout = vim.api.nvim_call_function("winlayout", {})
      if
         layout[1] == "leaf"
         and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree"
         and layout[3] == nil
      then
         vim.cmd("quit")
      end
   end,
})

return {
   "nvim-tree/nvim-tree.lua",
   dependencies = { "nvim-tree/nvim-web-devicons" },
   config = function()
      -- recommended settings from nvim-tree documentation
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- configure nvim-tree
      require("nvim-tree").setup({
         view = {
            -- width = 35,
            relativenumber = true,
            float = {
               enable = true,
               open_win_config = function()
                  local screen_w = vim.opt.columns:get()
                  local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                  local window_w = screen_w * WIDTH_RATIO
                  local window_h = screen_h * HEIGHT_RATIO
                  local window_w_int = math.floor(window_w)
                  local window_h_int = math.floor(window_h)
                  local center_x = (screen_w - window_w) / 2
                  local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
                  return {
                     border = "",
                     relative = "editor",
                     row = center_y,
                     col = center_x,
                     width = window_w_int,
                     height = window_h_int,
                  }
               end,
            },
            width = function()
               return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
            end,
         },
         -- change folder arrow icons
         renderer = {
            indent_markers = {
               enable = true,
            },
            icons = {
               glyphs = {
                  folder = {
                     arrow_closed = "", -- arrow when folder is closed
                     arrow_open = "", -- arrow when folder is open
                  },
               },
            },
         },
         -- disable window_picker for
         -- explorer to work well with
         -- window splits
         actions = {
            open_file = {
               window_picker = {
                  enable = false,
               },
            },
         },
         filters = {
            custom = {
               ".DS_Store",
               "^.git$",
               "*.aux",
               "*.fdb_latexmk",
               "*.fls",
               "*.lof",
               "*.idx",
               "*.ilg",
               "*.thm",
               "*.toc",
               "*.ist",
               "*.bst",
               "*.log",
               "*.ind",
               "*/*.aux",
               "*.xdv",
               "*.out",
               "main.synctex.gz",
               "*.bbl",
               "*.blg",
               "*.acn",
               "*.glo",
               "*.mst",
               "*.xml",
            },
         },
         git = {
            ignore = false,
         },
         -- on_attach
         on_attach = my_on_attach,
      })

      -- set keymaps
      vim.keymap.set("n", "<A-e>", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
      vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
      vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
   end,
}
