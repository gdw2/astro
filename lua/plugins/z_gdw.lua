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
  { import = "astrocommunity.editing-support.copilotchat-nvim" },
  { import = "astrocommunity.completion.copilot-cmp" },
  { import = "astrocommunity.completion.avante-nvim" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.motion.leap-nvim" },
  { import = "astrocommunity.motion.marks-nvim" },
  { import = "astrocommunity.editing-support.nvim-treesitter-context" },
  { import = "astrocommunity.code-runner.overseer-nvim" },
  {
    "yetone/avante.nvim",
    opts = {
      provider = "copilot",
      -- add any opts here
    },
  },
  -- nvim-notify controls how messages are displayed
  {
    "rcarriga/nvim-notify",
    opts = {
      -- top_down = false,
      timeout = 2000, -- shorter display duration, default 3000
      level = vim.log.levels.INFO,
      -- background_color = "#000000",
    },
  },
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
  },
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      local astro = require "astrocore"
      maps.n["<Leader>tc"] = { "<cmd>ToggleTermSendCurrentLine<cr>", desc = "Send Current Line" }
      maps.v["<Leader>tc"] = { "<cmd>ToggleTermSendVisualLines<cr>", desc = "Send Visual Lines" }
      maps.i["<C-CR>"] = { "<cmd>ToggleTermSendCurrentLine<cr>", desc = "Send Current Line" }
      maps.i["<C-s>"] = { "<cmd>ToggleTermSendCurrentLine<cr>", desc = "Send Current Line" }
      maps.n["<Leader>Mv"] = { "<cmd>OverseerRun Restart\\ viabox<cr>", desc = "Restart viabox" }

      -- I have to do this, or I get a stack trace. The `args` in the original is sometimes unset.
      -- Original is here: https://github.com/AstroNvim/AstroNvim/blob/e3434ed8ba30af34b36d270b0197b91e444b9363/lua/astronvim/plugins/telescope.lua#L71-L77
      if vim.fn.executable "rg" == 1 then
        maps.n["<Leader>fW"] = {
          function()
            require("telescope.builtin").live_grep {
              additional_args = { "--hidden", "--no-ignore" },
            }
          end,
          desc = "Find words in all files",
        }
        -- changing this from the default by adding --hidden so that it will
        -- search for files in the .ghithub dir.
        maps.n["<Leader>fw"] = {
          function()
            require("telescope.builtin").live_grep {
              additional_args = { "--hidden" },
            }
          end,
          desc = "Find words in all files",
        }
      end

      -- gh-dash support
      if vim.fn.executable "git" == 1 and vim.fn.executable "gh-dash" == 1 then
        maps.n["<Leader>g"] = vim.tbl_get(opts, "_map_sections", "g")
        local gh_dash = {
          callback = function()
            -- local worktree = astro.file_worktree()
            -- local flags = worktree and (" --work-tree=%s --git-dir=%s"):format(worktree.toplevel, worktree.gitdir)
            --   or ""
            -- astro.toggle_term_cmd { cmd = "gh-dash " .. flags, direction = "float" }
            astro.toggle_term_cmd { cmd = "GH_HOST=git.viasat.com gh-dash ", direction = "float" }
          end,
          desc = "ToggleTerm gh-dash",
        }
        maps.n["<Leader>g-"] = { gh_dash.callback, desc = gh_dash.desc }
        -- maps.n["<Leader>tl"] = { gh_dash.callback, desc = gh_dash.desc }
      end
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local astro = require "astrocore"
          -- <C-'>, for some reason, doesn't work in tmux or screen
          -- so, change it to <C-\\>
          maps.n["<C-\\>"] = { '<Cmd>execute v:count . "ToggleTerm"<CR>', desc = "Toggle terminal" } -- requires terminal that supports binding <C-'>
          maps.t["<C-\\>"] = { "<Cmd>ToggleTerm<CR>", desc = "Toggle terminal" } -- requires terminal that supports binding <C-'>
          maps.i["<C-\\>"] = { "<Esc><Cmd>ToggleTerm<CR>", desc = "Toggle terminal" } -- requires terminal that supports binding <C-'>
          maps.t["jk"] = { "<C-\\><C-n>", desc = "Escape terminal" }

          if vim.fn.executable "lazydocker" == 1 then
            maps.n["<Leader>td"] = {
              function() astro.toggle_term_cmd { cmd = "lazydocker", direction = "float" } end,
              desc = "ToggleTerm lazydocker",
            }
          end
        end,
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      formatting = {
        format_on_save = {
          enabled = true, -- enable or disable
          ignore_filetypes = { -- disable format on save for specified filetypes
            "cpp",
            "c",
          },
        },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
          always_show = { ".github" },
        },
      },
    },
  },
}
