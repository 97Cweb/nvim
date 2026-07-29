-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true

vim.opt.clipboard = "unnamedplus"

-- Leader key
vim.g.mapleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)
    end,
  },


  
  --git gutter
  {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup()
    end,
  },

  --Auto (),[],{} quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  -- Mason + LSP
  { "mason-org/mason.nvim", config = true },
  { "mason-org/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },

  -- Autocomplete
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },

  -- Nice status line
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup()
    end,
  },
})

-- LSP setup
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = { "basedpyright","ruff" },
})

vim.lsp.config("basedpyright", {
  capabilities = capabilities,
})

vim.lsp.enable("basedpyright")

vim.lsp.config("ruff", {
    capabilities = capabilities,
})
vim.lsp.enable("ruff")


vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--query-driver=/home/collin/.arduino15/packages/esp32/tools/esp-rv32/*/bin/riscv32-esp-elf-*",
    },
})

vim.lsp.enable("clangd")
vim.lsp.enable("clangd")

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        vim.lsp.buf.format({
            async = false,
            filter = function(client)
                return client.name == "ruff"
            end,
        })
    end,
})
-- Autocomplete setup
local cmp = require("cmp")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
  },
})

-- LSP keybinds
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
