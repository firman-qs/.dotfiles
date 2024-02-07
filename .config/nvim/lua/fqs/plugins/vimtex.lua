return {
   "lervag/vimtex",
   config = function()
      vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<CR>", { desc = "Compile me" })
      vim.keymap.set("n", "<leader>ls", "<cmd>VimtexStop<CR>", { desc = "Vimtex stop" })
      vim.keymap.set("n", "<leader>le", "<cmd>VimtexError<CR>", { desc = "Vimtex error" })
      vim.keymap.set("n", "<leader>li", "<cmd>VimtexInfo<CR>", { desc = "Vimtex Info" })
      vim.keymap.set("n", "<leader>lo", "<cmd>VimtexLog<CR>", { desc = "Vimtex Log" })
      function latex_template()
         return table.concat({
            "\\begin{center}",
            "<CR>",
            "\\begin{tikzpicture}",
            "<CR>",
            "\\draw (0, 0) node[inner sep=0] {\\incsvg{./figures/}{<C-R>z}};",
            "<CR>",
            "\\draw (1, 1) node {<C-R>z};",
            "<CR>",
            "\\end{tikzpicture}",
            "<CR>",
            "\\captionof{figure}{<C-R>z}",
            "<CR>",
            "\\label{<C-R>z}",
            "<CR>",
            "\\end{center}",
            "<CR>",
         }, "")
      end
      vim.keymap.set(
         "v",
         "<leader>ii",
         '"zy<Esc>:!inkscape-figures create <C-R>z ./figures <CR><CR><BAR>i' .. latex_template() .. "<CR><Esc>dd",
         { desc = "xxx" }
      )
      vim.keymap.set(
         "n",
         "<leader>ie",
         '"zy<Esc>:!inkscape-figures edit ./figures/<C-R>z<CR>',
         { desc = "edit inkscape" }
      )
      -- dse              |<plug>(vimtex-env-delete)|                     `n`
      -- dsc              |<plug>(vimtex-cmd-delete)|                     `n`
      -- ds$              |<plug>(vimtex-env-delete-math)|                `n`
      -- dsd              |<plug>(vimtex-delim-delete)|                   `n`
      -- cse              |<plug>(vimtex-env-change)|                     `n`
      -- csc              |<plug>(vimtex-cmd-change)|                     `n`
      -- cs$              |<plug>(vimtex-env-change-math)|                `n`
      -- csd              |<plug>(vimtex-delim-change-math)|              `n`
      -- tsf              |<plug>(vimtex-cmd-toggle-frac)|                `nx`
      -- tsc              |<plug>(vimtex-cmd-toggle-star)|                `n`
      -- tse              |<plug>(vimtex-env-toggle-star)|                `n`
      -- ts$              |<plug>(vimtex-env-toggle-math)|                `n`
   end,
}
