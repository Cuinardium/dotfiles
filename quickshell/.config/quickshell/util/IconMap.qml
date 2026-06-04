pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property var id_map: {
        "chromium":            { title: "Chromium",                  icon: "" },
        "firefox":             { title: "Firefox",                   icon: "󰈹" },
        "org.mozilla.firefox": { title: "Firefox",                   icon: "󰈹" },
        "kitty":               { title: "Kitty",                     icon: "" },
        "android-studio":      { title: "Android Studio",            icon: "󰀴" },
        "jetbrains-idea":      { title: "IntelliJ IDEA",             icon: "" },
        "neovim":              { title: "Neovim",                    icon: "" },
        "discord":             { title: "Discord",                   icon: "" },
        "mpv":                 { title: "MPV",                       icon: "" },
        "spotify":             { title: "Spotify",                   icon: "󰓇" },
        "libreoffice-base":    { title: "LibreOffice Base",          icon: "" },
        "libreoffice-calc":    { title: "LibreOffice Calc",          icon: "" },
        "libreoffice-draw":    { title: "LibreOffice Draw",          icon: "" },
        "libreoffice-impress": { title: "LibreOffice Impress",       icon: "" },
        "libreoffice-math":    { title: "LibreOffice Math",          icon: "" },
        "libreoffice-writer":  { title: "LibreOffice Writer",        icon: "" },
        "obsidian":            { title: "Obsidian",                  icon: "󱓧" },
        "libreoffice":         { title: "LibreOffice Default",       icon: "" },
        "title:libreoffice":   { title: "LibreOffice Dialogs",       icon: "" },
        "soffice":             { title: "LibreOffice Base Selector", icon: "" },
        "lofi.player":         { title: "Lofi Player",               icon: "󰥠" },
        "yazi":                { title: "Yazi",                      icon: "󰇥" },
        "term.float":          { title: "Kitty",                     icon: "󰄛" }
    }

    readonly property var title_map: {
        "youtube":         "",
        "microsoft teams": "󰊻",
        "whatsapp":        "󰖣",
        "nv":              "",
        "nvim":            "",
        "git":             "",
        "claude":          "󱚝",
        "opencode":        "󱜙",
        "oc | ":           "󱜙"
    }

    function getMatchById(appId) {
        if (!appId)
            return { title: "Desktop", icon: "󰇄" };

        const key = String(appId).toLowerCase();

        if (id_map[key] !== undefined)
            return id_map[key];

        return { title: "Unknown", icon: "󰣆" };
    }

    function getMatch(appId, title) {
        const match = getMatchById(appId);
        const resp = { title: match.title, icon: match.icon };

        const appsToSearch = ["Firefox", "Kitty"];
        if (appsToSearch.includes(match.title)) {
            const matchedTitle = Object.keys(title_map).find(key => title.toLowerCase().includes(key));
            if (matchedTitle)
                resp.icon = title_map[matchedTitle];
        }

        return resp;
    }
}
