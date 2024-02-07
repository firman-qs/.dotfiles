require("fqs.core")
require("fqs.lazy")
vim.g.python3_host_prog = "/usr/bin/python3"
require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/mysnippets/" })
