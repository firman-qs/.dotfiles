vim.g.mapleader = " "

vim.keymap.set("n", "<A-e>", vim.cmd.Ex, { desc = "Open Explorer" })
vim.keymap.set("n", "<A-s>", vim.cmd.w, { desc = "Save File" })

-- move line up and down and
vim.keymap.set("n", "<A-k>", ":m -2<CR>")
vim.keymap.set("n", "<A-j>", ":m +1<CR>")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
-- vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "yank to register" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "yank line to register" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "delete to another galaxy" })

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "normal mode" })

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set(
   "n",
   "<leader>s",
   [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
   { desc = "Replace word under cursor" }
)
vim.keymap.set("x", "<leader>S", '"zy<Esc>:%s/<C-R>z//g<Left><Left>', { desc = "Replace word under cursor" })

-- Visual --
-- Stay in indent mode
vim.keymap.set("v", "<A-h>", "<gv")
vim.keymap.set("v", "<A-l>", ">gv")
vim.keymap.set("n", "<A-h>", "<<")
vim.keymap.set("n", "<A-l>", ">>")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/.config/nvim/lua/fqs/lazy.lua<CR>")

vim.api.nvim_create_augroup("custom_buffer", { clear = true })
-- highlight yanks
vim.api.nvim_create_autocmd("TextYankPost", {
   group = "custom_buffer",
   pattern = "*",
   callback = function()
      vim.highlight.on_yank({ timeout = 200 })
   end,
})
