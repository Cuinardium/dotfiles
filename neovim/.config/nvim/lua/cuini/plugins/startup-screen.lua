return { {
    "goolord/alpha-nvim",
    lazy = false,
    config = function()
        local present, alpha = pcall(require, "alpha")
        if not present then
            return
        end

        local header = {
            type = "text",
            val = {
                '          ▀████▀▄▄              ▄█ ',
                '            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ',
                '    ▄        █          ▀▀▀▀▄  ▄▀  ',
                '   ▄▀ ▀▄      ▀▄              ▀▄▀  ',
                '  ▄▀    █     █▀   ▄█▀▄      ▄█    ',
                '  ▀▄     ▀▄  █     ▀██▀     ██▄█   ',
                '   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ',
                '    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ',
                '   █   █  █      ▄▄           ▄▀   ',
            },
            opts = {
                position = "center",
                hl = "type",
            },
        }

        local function getGreeting(name)
            local tableTime = os.date("*t")
            local hour = tableTime.hour
            local greetingsTable = {
                [1] = "  Sleep well",
                [2] = "  Good morning",
                [3] = "  Good afternoon",
                [4] = "  Good evening",
                [5] = "望 Good night",
            }
            local greetingIndex = 0
            if hour == 23 or hour < 7 then
                greetingIndex = 1
            elseif hour < 12 then
                greetingIndex = 2
            elseif hour >= 12 and hour < 18 then
                greetingIndex = 3
            elseif hour >= 18 and hour < 21 then
                greetingIndex = 4
            elseif hour >= 21 then
                greetingIndex = 5
            end
            return greetingsTable[greetingIndex] .. ", " .. name .. " "
        end

        local userName = "Cuini"
        local greeting = getGreeting(userName)

        local greetHeading = {
            type = "text",
            val = greeting,
            opts = {
                position = "center",
                hl = "keyword",
            },
        }

        local plugins = ""
        if vim.fn.has("linux") == 1 or vim.fn.has("mac") == 1 then
            local handle = io.popen(
            'ls -l $HOME/.local/share/nvim/lazy | wc -l | tr -d "\n" ')
            if handle == nil then
                return nil
            end
            plugins = handle:read("*a")
            handle:close()

            plugins = plugins:gsub("^%s*(.-)%s*$", "%1")
            plugins = tostring(tonumber(plugins) - 5)
        else
            plugins = "N/A"
        end

        local pluginCount = {
            type = "text",
            val = "  " .. plugins .. " plugins in total",
            opts = {
                position = "center",
                hl = "keyword"
            },
        }

        local quote = [[
    "Juanceto01, vos sabes que vas a ser el primer baneado.
    Ahí está, te cayo primero el ban."
]]
        local quoteAuthor = "Gerónimo Benavides Marchesi"
        local fullQuote = quote .. "\n \n                  - " .. quoteAuthor

        local fortune = {
            type = "text",
            val = fullQuote,
            opts = {
                position = "center",
                hl = "",
            },
        }

        local function button(sc, txt, keybind)
            local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

            local opts = {
                position = "center",
                text = txt,
                shortcut = sc,
                cursor = 6,
                width = 19,
                align_shortcut = "right",
                hl_shortcut = "Number",
                hl = "Function",
            }
            if keybind then
                opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
            end

            return {
                type = "button",
                val = txt,
                on_press = function()
                    local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
                    vim.api.nvim_feedkeys(key, "normal", false)
                end,
                opts = opts,
            }
        end

        local buttons = {
            type = "group",
            val = {
                button("s", "   Sessions", ":SessionManager load_session<CR>"),
                button("r", "   Recents", ":Telescope oldfiles<CR>"),
                button("p", "   Projects", ":Telescope project<CR>"),
                button("f", "   Search", ":Telescope find_files<CR>"),
                button("e", "   Create", ":ene <BAR> startinsert<CR>"),
                button("u", "   Update", ":Lazy sync<CR>"),
                button("c", "   Config", ":execute 'cd /home/cuini/.config/nvim'<CR>:e ~/.config/nvim/<CR>"),
                button("q", "   Quit", ":qa!<CR>"),
            },
            opts = {
                position = "center",
                spacing = 1,
            },
        }

        local section = {
            header = header,
            buttons = buttons,
            greetHeading = greetHeading,
            pluginCount = pluginCount,
            footer = fortune,
        }

        local opts = {
            layout = {
                { type = "padding", val = 5 },
                section.header,
                { type = "padding", val = 4 },
                section.greetHeading,
                section.pluginCount,
                { type = "padding", val = 3 },
                section.buttons,
                { type = "padding", val = 3 },
                section.footer,
            },
            opts = {
                margin = 44,
            },
        }
        alpha.setup(opts)
    end
} }
