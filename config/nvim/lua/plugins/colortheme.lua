return {
  -- 'EdenEast/nightfox.nvim',
  'Mofiqul/dracula.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    -- Toggle background transparency
    local bg_transparent = true

    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      vim.g.nord_disable_background = bg_transparent
      vim.cmd [[colorscheme nord]]
    end

    vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
  end,
}
