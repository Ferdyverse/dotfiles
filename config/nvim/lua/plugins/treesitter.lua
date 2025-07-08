-- treesitter.lua

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "elixir",
          "heex",
          "javascript",
          "html",
          "python",
          "bash",
          "dockerfile",
          "css",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
