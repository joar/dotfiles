local packer = nil
local function init()
    if packer == nil then
        packer = require 'packer'
        packer.init {
            disable_commands = true,
            display = {
                open_fn = function()
                    local result, win, buf = require('packer.util').float {
                        border = {
                            { '╭', 'FloatBorder' },
                            { '─', 'FloatBorder' },
                            { '╮', 'FloatBorder' },
                            { '│', 'FloatBorder' },
                            { '╯', 'FloatBorder' },
                            { '─', 'FloatBorder' },
                            { '╰', 'FloatBorder' },
                            { '│', 'FloatBorder' },
                        },
                    }
                    vim.api.nvim_win_set_option(win, 'winhighlight', 'NormalFloat:Normal')
                    return result, win, buf
                end,
            },
        }
    end

  local use = packer.use
  packer.reset()

  -- From joar
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  }
  use 'lambdalisue/suda.vim' -- sudo write/read for when you accidentally haven't sudo nvim'd
  use 'm-pilia/vim-pkgbuild' -- PKGBUILD syntax
  use 'rust-lang/rust.vim' -- rust syntax
  use 'vim-scripts/Unicode-RST-Tables' -- proper reST tables
  use 'elzr/vim-json' -- JSON syntax
  use 'motemen/git-vim'  -- ?
  use 'rhowardiv/nginx-vim-syntax'  -- nginx syntax
  use 'dag/vim-fish'  -- fish syntax
  use 'Glench/Vim-Jinja2-Syntax'  -- jinja2 syntax
  use 'Pocco81/auto-save.nvim' -- auto-save
  -- Fork of frankier/neovim-colors-solarized-only with clearly colored comments
  use 'joar/vim-colors-solarized'
  use 'justinmk/vim-sneak' -- jumps to any location specified by two characters
  use 'unblevable/quick-scope' -- highlights targets for `f`, `F` and family
  use 'hynek/vim-python-pep8-indent'
  use 'brooth/far.vim' -- Find and replace in multiple files
  use 'cespare/vim-toml' -- cargo TOML files
  -- use 'tpope/fugitive' -- git
  use 'kien/ctrlp.vim' -- buffer/file/tag finder
  use 'vito-c/jq.vim' -- jq syntax
  use 'danro/rename.vim'  -- rename file
  -- use 'stephpy/vim-yaml'  -- better YAML syntax -- ^W^W^W worse YAML syntax
  use 'fatih/vim-go' -- go development plugin
  use 'juliosueiras/vim-terraform-completion'  -- terraform
  use 'mhinz/vim-signify'  -- show git changes
  -- requirements.txt syntax
  use 'raimon49/requirements.txt.vim'
  -- Patch review mode
  --
  use 'editorconfig/editorconfig-vim' -- editorconfig support

  use 'junkblocker/patchreview-vim'

  -- Don't want to talk about it
  use 'eiginn/iptables-vim'

  use 'sbdchd/neoformat'  -- code formatting
  use 'itkq/fluentd-vim'  -- fluentd config syntax
  use 'mustache/vim-mustache-handlebars'  -- handlebars and mustache syntax
  use 'dense-analysis/ale'  -- async linting engine

  use 'vim-airline/vim-airline'  -- airline
  use 'vim-airline/vim-airline-themes' -- airline themes

  use 'sheerun/vim-polyglot'  -- language pack
  use 'jparise/vim-graphql'
  use 'killphi/vim-ebnf'
  use 'direnv/direnv.vim'
  use 'jamessan/vim-gnupg'  -- https://github.com/jamessan/vim-gnupg

  use 'SirVer/ultisnips' -- snippets
  use 'honza/vim-snippets' -- ultisnips dependency

  use 'hwayne/tla.vim' -- TLA+ and PlusCal syntax

  use 'aklt/plantuml-syntax'
  use {
      "cfmeyers/dbt.nvim",
      requires = {
          "nvim-lua/plenary.nvim",
          "nvim-telescope/telescope.nvim",
          "rcarriga/nvim-notify",
      },
  }

    -- From lydell
    use 'AndrewRadev/inline_edit.vim'
    use 'AndrewRadev/splitjoin.vim'
    use 'ap/vim-css-color'
    use 'ap/vim-you-keep-using-that-word'
    use 'bkad/CamelCaseMotion'
    use 'jamessan/vim-gnupg'
    use 'mileszs/ack.vim'
    use 'tpope/vim-characterize'
    use 'tpope/vim-commentary'
    use 'tpope/vim-repeat'  -- more better '.'-repeat
    use 'tpope/vim-surround'
    use 'tpope/vim-vinegar'
    use 'tpope/vim-sleuth'
    use 'junegunn/fzf'
    use 'junegunn/vim-easy-align'  -- Indentation, alignment
    use 'junegunn/vim-oblique'
    use 'junegunn/vim-pseudocl' -- dependency of vim-fnr
    use 'junegunn/vim-fnr' -- find and replace
    use 'ntpeters/vim-better-whitespace'
    use 'tommcdo/vim-exchange'
    use 'wellle/targets.vim'
    use 'whatyouhide/vim-lengthmatters'  -- highlights text that overflows textwidth
    use 'kchmck/vim-coffee-script'
    use 'terryma/vim-multiple-cursors'
end


local plugins = setmetatable({}, {
        __index = function(_, key)
            init()
            return packer[key]
        end,
    })

return plugins
