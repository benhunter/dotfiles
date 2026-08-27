-- VSCode Neovim Plugin Configuration (Layer 1)
-- Loaded via "vscode-neovim.neovimInitPath": "~/.config/nvim/vscode.lua"

-- Basic options
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 5

-- Keymaps & formatting
vim.keymap.set("n", "Q", "gq", { desc = "Format text" })

-- Clear search highlights on Esc
vim.keymap.set("n", "<Esc>", "<cmd:nohlsearch><CR>")
