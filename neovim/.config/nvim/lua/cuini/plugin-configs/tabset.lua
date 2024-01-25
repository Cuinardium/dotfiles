local tabset = Load_Plugin("tabset")

tabset.setup({
    defaults = {
        tabwidth = 4,
        expandtab = true,
    },

    languages = {
        {
            filetypes = { "java", "html", "css", "json" },
            config = {
                tabwidth = 2,
            }
        }
    }
})
