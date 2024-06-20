set tabstop=4
set shiftwidth=4
set splitright
set splitbelow
set scrolloff=12
set relativenumber
highlight clear SignColumn

call plug#begin()
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'jiangmiao/auto-pairs'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
	Plug 'nvim-telescope/telescope-file-browser.nvim'
	Plug 'kaarmu/typst.vim'
	Plug 'chomosuke/typst-preview.nvim', {'tag': 'v0.1.4'}
call plug#end()

let g:airline_theme='night_owl'

" ============= Typst Settings =============

au FileType typst let b:AutoPairs = AutoPairsDefine({'<?' : '?>', '$' : '$'})

function TypstWatch()
    split
    resize 5
    exec 'terminal ' .. 'typst watch ' .. expand("%:") 
	wincmd p
endfunc

nnoremap <silent>ff <cmd>Telescope find_files<cr>
nnoremap <silent>fg <cmd>Telescope live_grep<cr>
nnoremap <silent>fb <cmd>Telescope buffers<cr>
nnoremap <silent>fh <cmd>Telescope help_tags<cr>

autocmd FileType typst nnoremap <silent>fw :call TypstWatch()<cr>
autocmd FileType typst nnoremap <silent>fr :silent exec "!zathura " . expand("%:p:r") . ".pdf &"<cr>

lua << EOF
require('telescope').setup {}
require'nvim-treesitter.configs'.setup {
  indent = {
    enable = true
  }
}

require 'typst-preview'.setup {
  -- Setting this true will enable printing debug information with print()
  debug = false,

  -- Custom format string to open the output link provided with %s
  -- Example: open_cmd = 'firefox %s -P typst-preview --class typst-preview'
  open_cmd = nil,

  -- Setting this to 'always' will invert black and white in the preview
  -- Setting this to 'auto' will invert depending if the browser has enable
  -- dark mode
  invert_colors = 'never',

  -- This function will be called to determine the root of the typst project
  get_root = function(bufnr)
    return vim.api.nvim_buf_get_name(bufnr):match('(.*/)')
  end, 
}
EOF
