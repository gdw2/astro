if vim.g.neovide then
  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
end

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

vim.g.neovide_scale_factor = 0.8
vim.cmd "autocmd VimEnter * NeovideSetScaleFactor 0.8"

return {
  {
    "Olical/conjure",
    ft = { "clojure", "janet", "fennel", "racket", "hy", "scheme", "guile", "julia", "lua", "lisp", "python", "sql" },
  },

  -- { import = "astrocommunity.test.neotest" },
  -- {
  --   "nvim-neotest/neotest",
  --   dependencies = {
  --     { "nvim-neotest/neotest-python", opts = {
  --       python = "env/bin/python",
  --     } },
  --     opts = function(_, opts)
  --       if not opts.adapters then opts.adapters = {} end
  --       -- table.insert(opts.adapters, require "neotest-python"(require("astrocore").plugin_opts "neotest-python"))
  --     end,
  --     -- opts = {
  --     --   adapters = {
  --     --     require "nvim-neotest/neotest-python",
  --     --   },
  --     -- },
  --   },
  -- },
  { import = "astrocommunity.recipes.neovide" },
  { import = "astrocommunity.git.gitlinker-nvim" },
  { import = "astrocommunity.terminal-integration.toggleterm-manager-nvim" },
  { import = "astrocommunity.completion.copilot-cmp" },
  { import = "astrocommunity.pack.python" },
  -- {
  --   "jay-babu/project.nvim",
  --   opts = {
  --     manual_mode = true,
  --   },
  -- },
  {
    "AstroNvim/astrocore",
    opts = {
      rooter = {
        enabled = true,
        notify = true,
        autochdir = true,
      },
      -- options = {
      --   g = {
      --     neovide_scale_factor = 0.8,
      --   },
      -- },
    },
  },
  {
    "linrongbin16/gitlinker.nvim",
    opts = function(opts, _)
      local utils = require "astrocore"
      return utils.extend_tbl(opts, {
        router = {
          browse = {
            ["^git%.viasat%.com"] = require("gitlinker.routers").github_browse,
          },
        },
      })
    end,
    keys = {
      {
        "<leader>ccq",
        function()
          local input = vim.fn.input "Quick Chat: "
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      },

      -- Show help actions with telescope
      {
        "<leader>cch",
        function()
          local actions = require "CopilotChat.actions"
          require("CopilotChat.integrations.telescope").pick(actions.help_actions())
        end,
        desc = "CopilotChat - Help actions",
      },
      -- Show prompts actions with telescope
      {
        "<leader>ccp",
        function()
          local actions = require "CopilotChat.actions"
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    --         -- See Commands section for default commands if you want to lazy load on them
  },
}
