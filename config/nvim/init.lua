vim.g.mapleader = ' '
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth=2
vim.opt.tabstop=2
vim.opt.colorcolumn = "80"
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.g.gutentags_ctags_tagfile = '.git/tags'
vim.g.gutentags_exclude_filetypes = {'gitcommit', 'gitrebase', 'gitconfig'}
vim.filetype.add({ extension = { prr = 'prr' } })

-- bootstrap lazy.nvim -------------------------------------------------------
local lazypath = vim.fn.stdpath('data')..'/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({'git','clone',
  '--filter=blob:none',
  'https://github.com/folke/lazy.nvim.git',
  lazypath})
end
vim.opt.rtp:prepend(lazypath)

-- plugins -------------------------------------------------------------------
require('lazy').setup({
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,               -- load on start (it’s tiny)
  },
  {
    'ludovicchabant/vim-gutentags'
  },
  -- {
  --   'powerman/vim-plugin-AnsiEsc'
  -- },
{
  'danobi/prr',
  init = function()
    vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/lazy/prr/vim')
  end,
  config = function()
    local function set_prr_links()
      local link = function(from, to) vim.api.nvim_set_hl(0, from, { link = to }) end
      link('prrAdded',   'DiffAdd')
      link('prrRemoved', 'DiffDelete')
      link('prrHeader',  'Directory')
      link('prrIndex',   'Comment')
      link('prrChunkH',  'Function')
      link('prrTagName', 'Keyword')
      link('prrResult',  'String')
    end

    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = set_prr_links,
    })

    set_prr_links()
  end,
},
  {
    'echasnovski/mini.nvim',
    version = false,
    config  = function()
      require('mini.basics').setup({ options = { extra_ui = true } })
      -- require('mini.statusline').setup()

      -- do
      --   local ms = require('mini.statusline')
      --
      --   -- branch only, trimmed to 25 chars
      --   local function branch_section()
      --     local head = vim.b.gitsigns_head or ''
      --     if head == '' then
      --       local ok, v = pcall(vim.fn['FugitiveHead'])
      --       if ok and type(v) == 'string' and v ~= '' then head = v end
      --     end
      --     if head == '' then return '' end
      --
      --     if #head > 25 then head = head:sub(1, 22) .. '…' end
      --     return ' ' .. head
      --   end
      --
      --   ms.setup({
      --     content = {
      --       active = function()
      --         return ms.combine_groups({
      --           { hl = 'MiniStatuslineMode',     strings = { ms.section_mode({}) } },
      --           { hl = 'MiniStatuslineDevinfo',  strings = { branch_section() } },
      --           '%<',
      --           { hl = 'MiniStatuslineFilename', strings = { ms.section_filename({}) } },
      --           '%=',
      --           { hl = 'MiniStatuslineFileinfo', strings = { ms.section_fileinfo({}) } },
      --           { hl = 'MiniStatuslineLocation', strings = { ms.section_location({}) } },
      --         })
      --       end,
      --     },
      --   })
      -- end

      -- do
      --   local ms = require('mini.statusline')
      --
      --   -- Replace the built-in section_git with a shorter one
      --   ms.section_git = function()
      --     -- Prefer gitsigns; fallback to Fugitive; final fallback is `git rev-parse`
      --     local head = vim.b.gitsigns_head or ''
      --
      --     if head == '' then
      --       local ok, v = pcall(vim.fn['FugitiveHead'])
      --       if ok and type(v) == 'string' and v ~= '' then head = v end
      --     end
      --
      --     if head == '' then
      --       local ok2, out = pcall(vim.fn.systemlist, {
      --         'git', '-C', vim.fn.expand('%:p:h'), 'rev-parse', '--abbrev-ref', 'HEAD'
      --       })
      --       if ok2 and out and out[1] and out[1] ~= '' and out[1] ~= 'HEAD' then head = out[1] end
      --     end
      --
      --     if head == '' then return '' end
      --     if #head > 25 then head = head:sub(1, 22) .. '…' end
      --     return ' ' .. head
      --   end
      --
      --   ms.setup()
      -- end

      do
        local ms = require('mini.statusline')

        -- Replace the built-in section_git with a shorter one
        ms.section_git = function()
          -- Prefer gitsigns; fallback to Fugitive; final fallback is `git rev-parse`
          local head = vim.b.gitsigns_head or ''

          if head == '' then
            local ok, v = pcall(vim.fn['FugitiveHead'])
            if ok and type(v) == 'string' and v ~= '' then head = v end
          end

          if head == '' then
            local ok2, out = pcall(vim.fn.systemlist, {
              'git', '-C', vim.fn.expand('%:p:h'), 'rev-parse', '--abbrev-ref', 'HEAD'
            })
            if ok2 and out and out[1] and out[1] ~= '' and out[1] ~= 'HEAD' then head = out[1] end
          end

          if head == '' then return '' end
          if #head > 25 then head = head:sub(1, 22) .. '…' end
          return ' ' .. head
        end

        ms.setup(
          {
            content = {
              active = function()
                -- Use Mini’s own helpers so colors/HL groups stay identical
                local mode, mode_hl        = ms.section_mode({ trunc_width = 120 })
                local diagnostics          = ms.section_diagnostics({ trunc_width = 75 })
                local filename             = ms.section_filename({ trunc_width = 140, relative = 'git' })
                local fileinfo             = ms.section_fileinfo({ trunc_width = 120 })
                local location             = ms.section_location({ trunc_width = 75 })
                local git                  = ms.section_git({ trunc_width = 40 }) -- <- right side

                -- Left: MODE + diagnostics + filename  (no git here)
                -- Right: git + fileinfo + location
                return ms.combine_groups({
                  { hl = mode_hl,                   strings = { mode } },
                  { hl = 'MiniStatuslineDevinfo',   strings = { diagnostics } },
                  { hl = 'MiniStatuslineFilename',  strings = { filename, '%<' } }, -- truncate if long

                  { hl = 'MiniStatuslineFileinfo',  strings = { '%=' } },            -- split left/right

                  { hl = 'MiniStatuslineDevinfo',   strings = { git } },             -- <- moved here
                  -- { hl = 'MiniStatuslineFileinfo',  strings = { fileinfo } },
                  { hl = 'MiniStatuslineLocation',  strings = { location } },
                })
              end,
            },
          }
        )
      end

      require('mini.files').setup()
      require('mini.comment').setup()
      require('mini.surround').setup()
      require('mini.pick').setup()
      require('mini.ai').setup()
    end,
  },
  {
    'echasnovski/mini.extra',
    version = false,
    config = function()
      require('mini.extra').setup()
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local function on_attach(bufnr)
        local api = require('nvim-tree.api')
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.del('n', '<C-k>', { buffer = bufnr })
      end
      require('nvim-tree').setup({
        on_attach = on_attach,
      })
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
      vim.keymap.set('n', '<leader>nt', ':NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
      vim.keymap.set('n', '<leader>nf', ':NvimTreeFindFile<CR>', { desc = 'Find file in tree' })
    end,
  },
  
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   priority = 1000,
  --   config = function()
  --     require("gruvbox").setup({
  --       terminal_colors = true,
  --       contrast = "medium",
  --       palette_overrides = {},
  --       overrides = {},
  --     })
  --     vim.o.background = "light"
  --     vim.cmd("colorscheme gruvbox")
  --
  --     -- Better LSP hover & diagnostic floats
  --     vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  --       border = "rounded",
  --       max_width = 80,
  --       silent = true,
  --     })
  --
  --     vim.diagnostic.config({
  --       float = { border = "rounded", source = "if_many", focusable = false },
  --     })
  --
  --     -- Match float colors to theme
  --     vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
  --     vim.api.nvim_set_hl(0, "FloatBorder", { link = "FloatTitle" })
  --     -- Optional soft transparency
  --     vim.o.winblend = 0
  --   end,
  -- },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup {
        flavour = "latte",         -- pick your light flavour: latte, frappe, macchiato, mocha
        integrations = {
          native_lsp = {
            enabled = true,
            virtual_text = { errors = { "italic" }, warnings = { "italic" }, hints = { "italic" }, information = { "italic" } },
            underlines   = { errors = { "underline" }, warnings = { "underline" }, hints = { "underline" }, information = { "underline" } },
          },
        },
      }
      vim.cmd("colorscheme catppuccin")

      -- Better LSP hover & diagnostic floats
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
        max_width = 80,
        silent = true,
      })

      vim.diagnostic.config({
        float = { border = "rounded", source = "if_many", focusable = false },
      })

      -- Match float colors to Catppuccin
      vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
      vim.api.nvim_set_hl(0, "FloatBorder", { link = "FloatTitle" })
      -- Optional soft transparency
      vim.o.winblend = 0

      -- ====================================================================
      -- TMUX PANE DIMMING: Dim nvim when switching to other tmux panes
      -- ====================================================================
      -- When you switch away from a tmux pane containing nvim, this dims
      -- the nvim background/foreground to match tmux's window-style dimming.
      -- This works around nvim's termguicolors overriding tmux dimming.
      --
      -- To adjust dimming intensity, change the colors below:
      --   - FocusLost: inactive pane colors (currently matches tmux Option 14)
      --   - FocusGained: active pane colors (normal Catppuccin Latte)
      --
      -- To disable: comment out both autocmds below
      -- ====================================================================
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          -- Dim to slightly darker background when tmux pane loses focus
          vim.cmd("hi Normal guibg=#E9ECF1 guifg=#4c4f69")
        end,
      })

      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          -- Wait briefly for tmux to set the flag (FocusGained can fire before tmux hook completes)
          vim.defer_fn(function()
            -- Check if this was triggered by tmux window switch
            local switched = vim.fn.system('tmux show-option -gv @window_switched 2>/dev/null'):gsub('%s+', '')

            if switched == '1' then
              -- Clear the flag immediately
              vim.fn.system('tmux set-option -g @window_switched 0')

              -- Pulse effect: brighten then fade back
              local original = "#eff1f5"
              local steps = {
                "#f5f7fb",  -- slightly brighter
                "#fafcfe",  -- brighter
                "#ffffff",  -- brightest
                "#fafcfe",  -- back down
                "#f5f7fb",  -- back down
                original    -- original
              }

              for i, bg in ipairs(steps) do
                vim.defer_fn(function()
                  vim.cmd(string.format("hi Normal guibg=%s guifg=#4c4f69", bg))
                end, (i - 1) * 83)  -- 83ms per step = ~500ms total
              end
            else
              -- Just restore normal colors (regular pane switch)
              vim.cmd("hi Normal guibg=#eff1f5 guifg=#4c4f69")
            end
          end, 25)  -- 25ms delay to let tmux set the flag
        end,
      })
      -- ==================================================================
    end,
  },

  {
    'tpope/vim-rails',
    lazy = false,  -- it's light, just load always
  },
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G', 'Gdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GRename', 'GRemove', 'GBrowse' },
  },

  {
    'tpope/vim-eunuch',
    lazy = false,
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    -- keys = {
    --   { "<leader>lg", "<cmd>LazyGit<cr>:sleep 100m<CR>:call feedkeys('a')<CR>4", desc = "Open LazyGit" }
    -- }
  },

  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
      })
      vim.keymap.set('n', 'gS', require('treesj').split, { desc = 'Split arguments/block to multiline' })
      vim.keymap.set('n', 'gJ', require('treesj').join, { desc = 'Join arguments/block to single line' })
      vim.keymap.set('n', 'gM', require('treesj').toggle, { desc = 'Toggle split/join' })
    end,
  },

  {
    "nelstrom/vim-textobj-rubyblock",
    dependencies = "kana/vim-textobj-user",
    config = function()
      -- Ensure matchit.vim is loaded for % matching
      vim.cmd("runtime macros/matchit.vim")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "axkirillov/telescope-changed-files" },
    },
    config = function()
      local actions      = require("telescope.actions")
      local telescope    = require("telescope")
      local lga_actions  = require("telescope-live-grep-args.actions")
      local action_layout = require("telescope.actions.layout")

      telescope.setup {
        defaults = {
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top" },
          find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git", "--exclude", "node_modules" },
          file_ignore_patterns = { "node_modules/" },
          mappings = {
            i = {
              ["<C-y>"] = action_layout.toggle_preview,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.select_horizontal,
              ["<C-k>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-d>"] = actions.results_scrolling_down,
              ["<C-u>"] = actions.results_scrolling_up,
              ["<M-d>"] = actions.preview_scrolling_down,
              ["<M-u>"] = actions.preview_scrolling_up,
            },
            n = {
              ["<C-y>"] = action_layout.toggle_preview,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.select_horizontal,
              ["<C-k>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-d>"] = actions.results_scrolling_down,
              ["<C-u>"] = actions.results_scrolling_up,
              ["<C-S-d>"] = actions.preview_scrolling_down,
              ["<C-S-u>"] = actions.preview_scrolling_up,
            },
          },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),                 -- quote the prompt
                ["<C-g>"] = lga_actions.quote_prompt({ postfix = " -g " }), -- quote + append " -g "
              },
            },
          },
        },
        pickers = {
          lsp_document_symbols  = { symbol_width = 80, symbol_type_width = 12, show_line = false },
          lsp_workspace_symbols = { symbol_width = 80, symbol_type_width = 12, show_line = false },
        },
      }
      -- put this near your other keymaps, inside config()
      local ivy = require("telescope.themes").get_ivy

      -- <leader>gz => live_grep_args in a slim bottom pane (doesn't cover splits)
      vim.keymap.set("n", "<leader>gz", function()
        require("telescope").extensions.live_grep_args.live_grep_args(ivy({
          -- optional tweaks:
          height = 4,      -- fixed rows (ivy defaults to ~10)
          previewer = true, -- show preview in ivy if you want
        }))
      end, { desc = "Grep (args) — ivy bottom pane" })

      telescope.load_extension("fzf")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("changed_files")
      
      -- Set base branch for changed files
      vim.g.telescope_changed_files_base_branch = "origin/main"

      -- New mapping for "grep with args"
      vim.keymap.set("n", "<leader>gg", telescope.extensions.live_grep_args.live_grep_args, { desc = "Grep (args)" })
      vim.keymap.set('n', '<Leader>gw', function() require('telescope.builtin').grep_string() end, { desc = 'Telescope git grep' })
      vim.keymap.set('n', '<leader>gf', function()
        local changed_files = vim.fn.systemlist(
          "git diff --name-only $(git merge-base HEAD origin/main)"
        )

        if #changed_files == 0 then
          vim.notify("No changed files", vim.log.levels.WARN)
          return
        end

        require('telescope').extensions.live_grep_args.live_grep_args({
          search_dirs = changed_files,
          prompt_title = "Grep Changed Files (args)"
        })
      end, { desc = 'Grep changed files with args' })

      -- Changed files picker with pins support
      vim.keymap.set('n', '<Leader>ff', function()
        local ff_pins = require('ff_pins')
        local pickers = require('telescope.pickers')
        local finders = require('telescope.finders')
        local conf = require('telescope.config').values

        local pinned_files = ff_pins.get_all_files()

        -- Get git changed files
        local git_changed = vim.fn.systemlist(
          "git diff --name-only $(git merge-base HEAD origin/main 2>/dev/null || echo HEAD)"
        )

        -- Merge and dedupe
        local all_files = {}
        local seen = {}

        for _, file in ipairs(git_changed) do
          if not seen[file] and file ~= "" then
            table.insert(all_files, file)
            seen[file] = true
          end
        end

        for _, file in ipairs(pinned_files) do
          if not seen[file] and file ~= "" then
            table.insert(all_files, file)
            seen[file] = true
          end
        end

        if #all_files == 0 then
          vim.notify("No changed or pinned files", vim.log.levels.WARN)
          return
        end

        pickers.new({}, {
          prompt_title = 'Changed + Pinned Files',
          finder = finders.new_table({
            results = all_files,
            entry_maker = function(entry)
              return {
                value = entry,
                display = entry,
                ordinal = entry,
                path = entry,
              }
            end,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.file_sorter({}),
        }):find()
      end, { desc = 'Find changed + pinned files' })

      -- Pin management keybinds
      vim.keymap.set('n', '<Leader>pa', function()
        require('ff_pins').add_current_file()
      end, { desc = 'Pin current file' })

      vim.keymap.set('n', '<Leader>pp', function()
        require('ff_pins').add_pattern()
      end, { desc = 'Add glob pattern' })

      vim.keymap.set('n', '<Leader>pc', function()
        require('ff_pins').clear_all()
      end, { desc = 'Clear all pins' })

      vim.keymap.set('n', '<Leader>pv', function()
        require('ff_pins').view_pins()
      end, { desc = 'View pinned files/patterns' })
    end,
  },
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  --     -- "nvim-telescope/telescope-live-grep-args.nvim",
  --   },
  --   config = function()
  --     local actions = require("telescope.actions")
  --     require("telescope").setup {
  --       defaults = {
  --         sorting_strategy = "ascending",
  --         layout_config = { prompt_position = "top" },
  --         find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git', '--exclude', 'node_modules' },
  --         file_ignore_patterns = { 'node_modules/' },
  --         mappings = {
  --           i = {
  --             ["<C-n>"] = actions.cycle_history_next,
  --             ["<C-p>"] = actions.cycle_history_prev,
  --             ["<C-j>"] = actions.select_horizontal,
  --             ["<C-k>"] = actions.select_vertical,
  --           },
  --           n = {
  --             ["<C-n>"] = actions.cycle_history_next,
  --             ["<C-p>"] = actions.cycle_history_prev,
  --             ["<C-j>"] = actions.select_horizontal,
  --             ["<C-k>"] = actions.select_vertical,
  --           },
  --         },
  --       },
  --       pickers = {
  --         lsp_document_symbols = {
  --           symbol_width = 80,
  --           symbol_type_width = 12,
  --           show_line = false,
  --         },
  --         lsp_workspace_symbols = {
  --           symbol_width = 80,
  --           symbol_type_width = 12,
  --           show_line = false,
  --         },
  --       },
  --     }
  --     require("telescope").load_extension("fzf")
  --   end,
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "lua",
          "ruby",
          "html",
          "css",
          "scss",
          "javascript",
          "json",
          "yaml",
          "markdown",
          "markdown_inline",
          "gitcommit",
        },
        highlight = { enable = true },
        indent = { enable = true , disable = {"lua", "ruby"}},

        -- folding support
        fold = {
          enable = true,
          disable = {},
        },

        -- add text objects
        textobjects = {
          select = {
            enable = true,
            lookahead = true,  -- jump forward to textobject
            keymaps = {
              ["am"] = "@function.outer",  -- around method
              ["im"] = "@function.inner",  -- inside method
              ["ab"] = "@block.outer",     -- around block (begin/end, do/end, etc.)
              ["ib"] = "@block.inner",     -- inside block
            },
          },
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  {
    "RRethy/nvim-treesitter-endwise",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup {
        endwise = { enable = true },
      }
    end,
  },
  
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      -- Set up default capabilities with position encoding
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.general = capabilities.general or {}
      capabilities.general.positionEncodings = { "utf-16", "utf-8" }

      lspconfig.ruby_lsp.setup({
        cmd = { "ruby-lsp" },
        cmd_env = { RUBY_YJIT_ENABLE = "1" },
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
        single_file_support = false,
        init_options = {
          addonSettings = {
            ["Ruby LSP Rails"] = {
              enablePendingMigrationsPrompt = false
            }
          },
          indexing = {
            includedPatterns = {
              "app/**/*.rb",
              "lib/**/*.rb",
              "db/schema.rb",
            },
            excludedPatterns = {
              "**/node_modules/**", "**/vendor/**", "**/tmp/**", "**/log/**",
              "**/coverage/**", "**/fixtures/**", "**/spec/**", "**/test/**",
              "**/db/migrate/**",
              "**/*.min.rb",
            },
            excludedGems = {
              "aws-sdk-*", "google-apis-*", "grpc", "rubocop", "sorbet", "rails-dom-testing",
            },
          },
        },

        on_attach = function(_, bufnr)
          local telescope = require("telescope.builtin")
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
          end

          map("<leader>ld", telescope.lsp_definitions,            "LSP: definition")
          map("<leader>lr", telescope.lsp_references,                 "LSP: references")
          map("<leader>li", telescope.lsp_implementations,            "LSP: implementations")
          map("<leader>lt", telescope.lsp_type_definitions,           "LSP: type definition")
          map("<leader>la", vim.lsp.buf.code_action,           "LSP: code action")
          map("<leader>rn", vim.lsp.buf.rename,                "LSP: rename")
          map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "LSP: format")
          map("<leader>ls", telescope.lsp_document_symbols,           "LSP: document symbols")
          map("<leader>lS", telescope.lsp_workspace_symbols,          "LSP: workspace symbols")

          -- Diagnostics via leader, too
          map("<leader>le", vim.diagnostic.open_float,         "Line diagnostics")
          map("<leader>lj", vim.diagnostic.goto_next,          "Next diagnostic")
          map("<leader>lk", vim.diagnostic.goto_prev,          "Prev diagnostic")
          map("<leader>lq", vim.diagnostic.setloclist,         "Diagnostics list")
          map("<leader>lR", "<cmd>LspRestart<cr>",             "LSP: restart")

          -- local opts = { buffer = bufnr, silent = true }
          -- vim.keymap.set("n", "gd", telescope.lsp_definitions, opts)
          -- vim.keymap.set("n", "gr", telescope.lsp_references, opts)
          -- vim.keymap.set("n", "gi", telescope.lsp_implementations, opts)
          -- vim.keymap.set("n", "gt", telescope.lsp_type_definitions, opts)
          --
          -- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        end,
      })
    end,
  },
  -- Completion --------------------------------------------------------
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'f3fora/cmp-spell' 
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })

      vim.o.completeopt = "menu,menuone,noselect"

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>']      = cmp.mapping.confirm({ select = false }),
          ['<C-y>']     = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-e>']     = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),

        -- Markdown/git commit spell
        cmp.setup.filetype({ 'markdown', 'gitcommit' }, {
          sources = cmp.config.sources({
            { name = 'buffer' },
            { name = 'spell' },
            { name = 'path' },
            { name = 'luasnip' },
          }),
        })
      })
    end,
  },
  -- End Completion --------------------------------------------------------
  {
    'wellle/targets.vim',
    event = 'VeryLazy',
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup{
        on_attach = function(bufnr)
          local gitsigns = require('gitsigns')

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation (center screen after jump)
          map('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal({']c', bang = true})
            else
              gitsigns.nav_hunk('next')
            end
            vim.cmd('normal! zz')
          end)

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({'[c', bang = true})
            else
              gitsigns.nav_hunk('prev')
            end
            vim.cmd('normal! zz')
          end)

          -- Actions
          map('n', '<leader>hs', gitsigns.stage_hunk )
          map('n', '<leader>ha', gitsigns.stage_hunk )
          map('n', '<leader>hr', gitsigns.reset_hunk)

          map('v', '<leader>hs', function()
            gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end)
        end
      }
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = "cd app && npm install",
    config = function()
      vim.g.mkdp_combine_preview = 1
      vim.g.mkdp_auto_close = 0  -- Required when using combine_preview
    end,
  },
  {
    "dkarter/bullets.vim",
    ft = "markdown",
    config = function()
      vim.g.bullets_enabled_file_types = { 'markdown', 'text', 'gitcommit' }
      vim.g.bullets_renumber_on_change = '0'
    end,
  },
  {
    'sindrets/diffview.nvim', config = function()
      require('diffview').setup()
    end
  },
  -- {
  --   'tpope/vim-projectionist',
  --   lazy   = false,  -- tiny, load immediately
  --   config = function()
  --     vim.g.projectionist_heuristics = {
  --       -- Rails / Minitest
  --       ['app/*.rb'] = {
  --         alternate = 'test/{}_test.rb',
  --         type      = 'source',
  --       },
  --       ['test/*_test.rb'] = {
  --         alternate = 'app/{}.rb',
  --         type      = 'test',
  --       },
  --     }
  --   end,
  -- },
  {
    'tpope/vim-unimpaired',
  },
  {
    "jpalardy/vim-slime",
    init = function()
      vim.g.slime_no_mappings = 1
    end,
    config = function()
      -- Send text to tmux pane
      vim.g.slime_target = "tmux"
      vim.g.slime_bracketed_paste = 1

      -- Keymaps
      vim.keymap.set("n", "<Leader>sl", "<Plug>SlimeLineSend", { desc = "Send line to tmux" })
      vim.keymap.set("v", "<Leader>sl", "<Plug>SlimeRegionSend", { desc = "Send selection to tmux" })
      vim.keymap.set("n", "<Leader>sf", "mBggVG<Plug>SlimeRegionSend<Esc>`B", { desc = "Send whole file to tmux" })
      vim.keymap.set("n", "<Leader>sr", ":unlet b:slime_config<CR>", { desc = "Send whole file to tmux" })
    end,
  },
  {
    'mbbill/undotree',
    keys = {
      { '<leader>u', vim.cmd.UndotreeToggle, desc = 'Toggle undotree' },
    },
  }
})

-- Basics
vim.keymap.set('n', '<Leader>w', ':w<CR>', { silent = true, desc = 'Save buffer' })
vim.keymap.set('n', '<Leader>we ', ':w<CR>', { silent = true, desc = 'Save buffer' })
vim.keymap.set('n', '<Leader>w<space>', ':w<CR>', { silent = true, desc = 'Save buffer' })
vim.keymap.set('n','<Leader>q', ':q<CR>', { silent=true })		
vim.keymap.set('n','<Leader>wq', ':wq<CR>',{ silent=true })
vim.keymap.set('n','<Leader><Leader>', ':nohlsearch<CR>', { silent=true, desc = 'Unhighlight' })
vim.api.nvim_create_autocmd('FocusLost', { command = 'wa' })
vim.keymap.set('i','jk','<Esc>:w<CR>',{desc='Esc+save'})
vim.keymap.set('n','q','<nop>',{ desc = 'Disable macro recording' })
vim.keymap.set('n', 'Q', 'q', { desc = 'Record macro' })
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 5
vim.keymap.set('n','<Leader>sp', ':set paste!<CR>', { silent = true, desc = "Toggle set paste" })
vim.cmd("iabbrev teh the")
vim.cmd("iabbrev tn: Technical notes:<CR><CR>")

-- copy file contents to clipboard
vim.keymap.set('n', '<leader>cf', function()
  vim.cmd(':%y+')
  vim.notify('Copied file contents to clipboard', vim.log.levels.INFO)
end, { desc = 'Copy file contents to clipboard' })

-- copy filename to system clipboard
vim.keymap.set('n', '<leader>cpr', function()
  local fname = vim.fn.expand('%')
  vim.fn.setreg('+', fname)
  vim.notify('Copied filename: ' .. fname, vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = 'Copy current filename' })

-- copy filename + line number (repo relative) to system clipboard
vim.keymap.set('n', '<leader>cpl', function()
  local fname = vim.fn.expand('%')
  local lnum  = vim.fn.line('.')
  local out   = fname .. ':' .. lnum
  vim.fn.setreg('+', out)
  vim.notify('Copied file:line ' .. out, vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = 'Copy filename:line' })

-- copy full path to system clipboard
vim.keymap.set('n', '<leader>cpf', function()
  local fpath = vim.fn.expand('%:p')
  vim.fn.setreg('+', fpath)
  vim.notify('Copied file path: ' .. fpath, vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = 'Copy current file path' })

-- Open Files
-- mini files based ctrl+p
-- vim.keymap.set('n', '<C-p>', function() require('mini.extra').pickers.git_files() end, { desc = 'Fuzzy-find git files' })
-- vim.keymap.set('n', '<Leader>ff', function() require('mini.extra').pickers.git_files() end, { desc = 'Git files' })
-- vim.keymap.set('n', '<Leader>fa', function() require('mini.pick').builtin.files() end, { desc = 'All files' })
-- vim.keymap.set('n', '<C-p>',      "<cmd>Telescope find_files<CR>", { desc = "Find files" })
-- vim.keymap.set('n', '<Leader>ff', "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set('n','<C-p>', function()
  pcall(require('telescope.builtin').git_files)  -- fast git index  
end, { desc = 'Find files (git)' })
vim.keymap.set('n','<Leader>fg', function()
  pcall(require('telescope.builtin').git_files)  -- fast git index  
end, { desc = 'Find files (git)' })
vim.keymap.set("n", "<M-p>", function()
  require("telescope.builtin").git_files(require("telescope.themes").get_ivy({
    -- optional tweaks:
    height = 4,       -- keep it slim like a drawer
    previewer = true, -- show preview inside the ivy layout if you like
  }))
end, { desc = "Find files (git) — ivy bottom pane" })
vim.keymap.set("n", "<leader>fz", function()
  require("telescope.builtin").git_files(require("telescope.themes").get_ivy({
    -- optional tweaks:
    height = 4,       -- keep it slim like a drawer
    previewer = true, -- show preview inside the ivy layout if you like
  }))
end, { desc = "Find files (git) — ivy bottom pane" })
vim.keymap.set('n', '<Leader>fa', '<Cmd>Telescope find_files<CR>', { desc = 'Find files (Telescope)' })
vim.keymap.set('n', '<Leader>fy', function()
  require('telescope.builtin').find_files({
    cwd = 'test/factories',
    prompt_title = 'Test Factories'
  })
end, { desc = 'Find factory files' })
vim.keymap.set('n', '<Leader>fn', function()
  require('telescope.builtin').find_files({ cwd = vim.fn.expand('~/working-notes') })
end, { desc = 'Find files in playbook' })
vim.keymap.set('n', '<Leader>fb', function()
  require('telescope.builtin').find_files({ cwd = vim.fn.expand('~/code/playbook') })
end, { desc = 'Find files in playbook' })
-- vim.keymap.set('n', '<Leader>ft', function()
--   require('telescope.builtin').find_files({ cwd = vim.fn.expand('~/alfred/todos') })
-- end, { desc = 'Find files in playbook' })
-- vim.keymap.set('n', '<Leader>gg', function() require('telescope.builtin').live_grep() end, { desc = 'Telescope live grep with args' })
-- vim.keymap.set('n', '<Leader>gw', function() require('telescope.builtin').grep_string() end, { desc = 'Telescope git grep' })
vim.keymap.set('n','<Leader>fr', function()
  pcall(require('telescope.builtin').registers)  -- fast git index  
end, { desc = 'Find files (git)' })
vim.keymap.set('n','<Leader>fh', function()
  pcall(require('telescope.builtin').help_tags)  -- fast git index  
end, { desc = 'Find files (git)' })
vim.keymap.set('n', '<Leader>mf', function()
  require('mini.files').open(vim.api.nvim_buf_get_name(0))
end, { desc = 'Open current file in mini.files' })

-- Folding Support
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = false  -- Don't fold by default
vim.opt.foldlevel = 99      -- High fold level so most folds are open by default

-- FOLDING KEYMAPS:
vim.keymap.set('n', '<leader>zz', function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal! zM')
  vim.api.nvim_win_set_cursor(0, cursor_pos)
  vim.cmd('normal! zv')
  vim.cmd('normal! zz')
end, { desc = 'Focus on current location' })
vim.keymap.set('n', '<leader>zc', 'zM', { desc = 'Close all folds' })
vim.keymap.set('n', '<leader>zo', 'zR', { desc = 'Open all folds' })
vim.keymap.set('n', '<leader>z1', function() vim.opt.foldlevel = 1 end, { desc = 'Fold level 1' })
vim.keymap.set('n', '<leader>z2', function() vim.opt.foldlevel = 2 end, { desc = 'Fold level 2' })
vim.keymap.set('n', '<leader>z3', function() vim.opt.foldlevel = 3 end, { desc = 'Fold level 3' })
vim.keymap.set('n', '<leader>z0', function() vim.opt.foldlevel = 0 end, { desc = 'Fold level 0 (all closed)' })

-- window/split movement/management
vim.opt.splitright = true
vim.keymap.set('n','<C-w>t', ':tabe<CR>', { silent=true, desc='New tab' })
-- vim.keymap.set('n', '<C-h>', '<C-w>h')
-- vim.keymap.set('n', '<C-j>', '<C-w>j')
-- vim.keymap.set('n', '<C-k>', '<C-w>k')
-- vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n','<Left>', ':vertical resize +5<CR>')		
vim.keymap.set('n','<Right>', ':vertical resize -5<CR>')		
vim.keymap.set('n','<Up>', ':resize +5<CR>')		
vim.keymap.set('n','<Down>', ':resize -5<CR>')
vim.keymap.set('n','<C-w>e','<C-w>=')
vim.keymap.set('n','<C-w><C-e>','<C-w>=')
vim.keymap.set('n','<C-w><C-w>', '<C-w>_<C-w>|', { desc = 'Maximize' })
vim.keymap.set('n','gr','gT', { nowait = true, desc='Prev tab' })
-- vim.keymap.set('n','gr'', { nowait = true, desc='Prev tab' })
vim.keymap.set('n','<Leader>ll','<C-^>',{desc='Last-file'})

-- prr
-- "Automatically set up highlighting for `.prr` review files
-- "Use `:hi` to see the various definitions we kinda abuse here augroup Prr
--   autocmd!
--   autocmd BufRead,BufNewFile *.prr set syntax=on
-- 
--   -- "Make prr added/deleted highlighting more apparent
--   autocmd BufRead,BufNewFile *.prr hi! link prrAdded Function
--   autocmd BufRead,BufNewFile *.prr hi! link prrRemoved Keyword
--   autocmd BufRead,BufNewFile *.prr hi! link prrFile Special
-- 
--   -- "Make file delimiters more apparent
--   autocmd BufRead,BufNewFile *.prr hi! link prrHeader Directory
-- 
--   -- "Reduce all the noise from color
--   autocmd BufRead,BufNewFile *.prr hi! link prrIndex Special
--   autocmd BufRead,BufNewFile *.prr hi! link prrChunk Special
--   autocmd BufRead,BufNewFile *.prr hi! link prrChunkH Special
--   autocmd BufRead,BufNewFile *.prr hi! link prrTagName Special
--   autocmd BufRead,BufNewFile *.prr hi! link prrResult Special
-- augroup END


-- Close LSP hover with <Esc> or <C-c>
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lspinfo,lsp-hover", -- depends on how your Neovim reports the filetype
  callback = function()
    vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "<C-c>", "<cmd>close<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
  end,
})

-- Markdown previewing
vim.keymap.set('n', '<leader>mp', ':MarkdownPreview<CR>', { desc = 'Markdown preview' })
vim.keymap.set('n', '<leader>ms', ':MarkdownPreviewStop<CR>', { desc = 'Stop markdown preview' })

-- -- Markdown Custom checkbox toggle for todos
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'markdown',
--   callback = function()
--     vim.keymap.set('n', '<leader>x', function()
--       local line = vim.api.nvim_get_current_line()
--       if line:match('%s*- %[ %]') then
--         -- Toggle unchecked to checked
--         local new_line = line:gsub('- %[ %]', '- [x]', 1)
--         vim.api.nvim_set_current_line(new_line)
--       elseif line:match('%s*- %[x%]') then
--         -- Toggle checked to unchecked
--         local new_line = line:gsub('- %[x%]', '- [ ]', 1)
--         vim.api.nvim_set_current_line(new_line)
--       end
--     end, { buffer = true, desc = 'Toggle markdown checkbox' })
--   end,
-- })

-- Markdown / git commit
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
    vim.opt_local.textwidth = 80
    vim.opt_local.formatoptions:append("t")
    vim.opt_local.colorcolumn = "80"

    -- Make "=" a format operator
    vim.keymap.set("n", "=", "gq", { buffer = true })
    vim.keymap.set("x", "=", "gq", { buffer = true })
    vim.keymap.set("n", "==", "gqip", { buffer = true })

    -- Ensure Vim's formatter is used (not LSP)
    vim.opt_local.formatexpr = ""
  end,
})

-- git commit formatting and reflow with =
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.textwidth = 72
    vim.opt_local.formatoptions:append("t")
    vim.opt_local.colorcolumn = "73"
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"

    -- Make "=" a format operator (just like gq)
    vim.keymap.set("n", "=", "gq", { buffer = true })
    vim.keymap.set("x", "=", "gq", { buffer = true })

    -- Optional: keep a 1-key “format this paragraph now”
    vim.keymap.set("n", "==", "gqip", { buffer = true })

    -- Ensure Vim's formatter is used (not LSP):
    vim.opt_local.formatexpr = ""
  end,
})
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "gitcommit",
--   callback = function()
--     vim.opt_local.textwidth = 72
--     vim.opt_local.formatoptions:append("t")
--     vim.opt_local.colorcolumn = "73"
--     vim.opt_local.spell = true
--     vim.opt_local.spelllang = "en_us"
--
--     vim.keymap.set("n", "=", "gqip", { buffer = true })
--     vim.keymap.set("v", "=", "gq",   { buffer = true })
--   end,
-- })

-- nvim config
vim.keymap.set('n', '<Leader>vr', ':source ~/.config/nvim/init.lua<CR>', { desc = 'Sync & reload plugins' })
vim.keymap.set('n','<Leader>vv',':tabnew $MYVIMRC<CR>')
vim.keymap.set('n','<Leader>vg',':tabnew $MYVIMRC<CR>')
vim.keymap.set('n','<Leader>va',':tabnew ~/.aliases<CR>')
vim.keymap.set('n','<Leader>vz',':tabnew ~/.zshrc<CR>')
vim.keymap.set('n','<Leader>vt',':tabnew ~/.tmux.conf<CR>')
vim.keymap.set('n','<Leader>vg',':tabnew ~/.gitconfig<CR>')

-- Backup/swp files disable
vim.opt.backup = false; vim.opt.writebackup = false; vim.opt.swapfile = false

-- text objects
-- Select entire file as a text object
vim.keymap.set({ 'o', 'x' }, 'af', function()
  vim.cmd.normal({ 'gg0vG$', bang = true })  -- charwise: start of file → end of last line
end, { desc = 'Around file' })

-- Optional: inner-file behaves the same
vim.keymap.set({ 'o', 'x' }, 'if', function()
  vim.cmd.normal({ 'gg0vG$', bang = true })
end, { desc = 'Inner file' })

-- Comment hotkey
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment line" })
vim.keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment selection" })
-- iterm2 and nvim weird interpret a / as a _ in some/all? cases
vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment line" })
vim.keymap.set("v", "<C-_>", "gc", { remap = true, desc = "Toggle comment selection" })


-- Ruby/Rails
vim.keymap.set('n','<Leader>bb',"obinding.pry<Esc>",{desc='pry'})
vim.keymap.set('n','<Leader>BB',"Obinding.pry<Esc>",{desc='pry above'})
vim.keymap.set('n','<Leader>a', ':A<CR>', { desc = 'Jump to alternate (test ↔ source)' })
vim.keymap.set('n', '<leader>rf', function()
  local file = vim.fn.expand('%')
  vim.fn.system('rubocop -A ' .. vim.fn.shellescape(file))
  vim.cmd('e!')
  vim.notify('RuboCop auto-correct complete')
end, { desc = 'RuboCop auto-correct all' })

-- Auto-format Ruby files on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rb",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})


-- ==== Fugitive / Git shortcuts ==============================================
-- Helper for brevity
local map = function(lhs, rhs)
  vim.keymap.set('n', lhs, rhs, { silent = true })
end

map('<leader>G',      ':Git ')                                -- open “:Git …” prompt
map('<leader>gst',    ':Git<CR>')                             -- status
map('<leader>gp',     ':Git pull<CR>')
map('<leader>gpush',  ':Git push ')                           -- leave space for args
map('<leader>gfwl',  ':Git push --force-with-lease')          -- leave space for args
-- map('<leader>gls',    ':Commits<CR>')                      -- commits list
vim.keymap.set('n', '<leader>glg', function()
  vim.cmd('LazyGit')
  vim.defer_fn(function()
    vim.api.nvim_feedkeys('4', 'n', false)
  end, 100)
end, { desc = 'Open LazyGit to commits panel' })
vim.keymap.set('n', '<leader>gls', function()
  vim.cmd('LazyGit')
  vim.defer_fn(function()
    vim.api.nvim_feedkeys('4', 'n', false)
  end, 100)
end, { desc = 'Open LazyGit to commits panel' })
-- map('<leader>gls',    ':LazyGit<CR>4')                         -- commits list

map('<leader>gbl',    ':Git blame<CR>', { desc = 'Git blame file' })
map('<leader>gdr',    ':!clear; git log -p<CR>')              -- full patch log
map('<leader>gdrf',   ':!clear; git log -p %<CR>')            -- patch log for this file
map('<leader>gsh', function()
  require('telescope.builtin').git_commits()
end, { desc = 'Git show (Telescope picker)' })
map('<leader>ga',     ':Git add -p %<CR>')            -- stage current file interactively
map('<leader>gA',     ':Git add -p<CR>')               -- stage all files interactively
map('<leader>gci',    ':Git ci<CR>')                          -- commit
map('<leader>gca',    ':Git ci --amend<CR>')                  -- amend last commit
map('<leader>gcf',    ':!git checkout % ')                     -- checkout another rev of this file

map('<leader>ft', function() 
  require('telescope.builtin').live_grep({ 
    search_dirs = { vim.fn.expand('%:p') },
    default_text = 'test |should |context ',
    path_display = { 'hidden' }
  })
end, { desc = 'Show test lines in current file' })
map("<leader>gba", function() require('telescope.builtin').git_branches() end,        {desc = "Git branches (all)"})
map("<leader>gbr", function() require('telescope.builtin').git_branches({
  show_remote_tracking_branches = false,
  default_text = "z/ | main",
}) end,        {desc = "Git branches (local)"})
map('<leader>gcm',    ':Git checkout ma')                     -- start checkout to “ma…” (tab-complete)
map('<leader>gcl',    ':Git checkout -<CR>')                  -- switch to prev branch
map('<leader>gcb',    ':Git checkout -b ')                    -- new branch
map('<leader>gco',    ':Git checkout ')                       -- generic checkout
map('<leader>grm',    ':Git rebase origin/master ')           -- rebase onto origin/master
map('<leader>gri',    ':Git rebase -i HEAD~~~~<CR>')          -- interactive rebase last 4 commits
map('<leader>gml',    ':Git merge --no-ff -<CR>')             -- merge prev branch (no-ff)
map('<leader>gm',     ':Git merge --no-ff ')                  -- prepare merge
map('<leader>gd',     ':Git diff -w<CR>')                     -- diff (ignore whitespace)
map('<leader>gdd',     ':Git diff -w<CR>')                     -- diff (ignore whitespace)
map('<leader>gdf',    ':!clear; git diff -w %<CR>')           -- diff current file
map('<leader>gds',    ':Git diff --staged -w<CR>')            -- diff staged
map('<leader>gsl',    ':!clear; git stash list<CR>')          -- stash list
map('<leader>gsd',    ':!clear; git stash show -p<CR>')       -- stash diff
map('<leader>gss',    ':!clear; git stash save ')             -- new stash (add msg next)
map('<leader>gsp',    ':!clear; git stash pop stash@{ ')      -- start stash pop
-- ============================================================================

-- AnsiEsc: automatically process ANSI escape codes in log files
-- vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
--   pattern = "*.log",
--   callback = function()
--     vim.cmd("AnsiEsc")
--   end,
-- })
--
-- Force-disable Tree-sitter indent for Ruby-family buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "eruby", "rake", "gemspec", "podspec" },
  callback = function()
    pcall(vim.cmd, "TSBufDisable indent")
    -- Make sure we fall back to non-TS indentexpr
    if vim.opt_local.indentexpr:get() == 'nvim_treesitter#indent()' then
      vim.opt_local.indentexpr = ''
    end
  end,
})
