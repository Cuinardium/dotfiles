return {
    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function() return vim.fn.executable 'make' == 1 end,
            },
            { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            telescope.setup {
                defaults = {
                    prompt_prefix = "   ",
                    selection_caret = " ",
                    -- Modern preference: shows filename then the path
                    path_display = { "filename_first" }, 
                    
                    file_ignore_patterns = { "node_modules", ".git/", ".cache", "%.class$" },

                    mappings = {
                        i = {
                            ["<C-c>"] = actions.close,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        },
                        n = {
                            ["<esc>"] = actions.close,
                            ["q"] = actions.close,
                        },
                    },
                },
                pickers = {
                    -- Fixed your buffer delete logic
                    buffers = {
                        mappings = {
                            n = {
                                ["d"] = function(prompt_bufnr)
                                    local selection = action_state.get_selected_entry()
                                    actions.close(prompt_bufnr)
                                    vim.api.nvim_buf_delete(selection.bufnr, { force = true })
                                end,
                            },
                        },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            }

            -- Load extensions safely
            pcall(telescope.load_extension, 'fzf')
            pcall(telescope.load_extension, 'ui-select')
            pcall(telescope.load_extension, 'file_browser')
        end
    }
}
