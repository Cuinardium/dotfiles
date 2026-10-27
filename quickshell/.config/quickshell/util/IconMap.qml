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
        "obsidian":            { title: "Obsidian",                  icon: "" },
        "libreoffice":         { title: "LibreOffice Default",       icon: "" },
        "title:libreoffice":   { title: "LibreOffice Dialogs",       icon: "" },
        "soffice":             { title: "LibreOffice Base Selector", icon: "" },
        "lofi.player":         { title: "Lofi Player",               icon: "󰥠" },
        "yazi":                { title: "Yazi",                      icon: "󰇥" },
        "term.float":          { title: "Kitty",                     icon: "󰄛" },
        "teams-for-linux":     { title: "Microsoft Teams",           icon: "󰊻" },
        // Los agentes (claude code, opencode, pi) corren en kitty con
        // --class agent. El título real es "Pi-<id>", "Claude-<id>", ...
        "agent":               { title: "pi Harness",                icon: "󰚩" }
    }

    // --- Overrides por título de ventana --------------------------------------
    // Se miran SÓLO las claves del scope de la app (appId normalizado), así una
    // pestaña de Firefox no puede disparar el ícono de un agente ni al revés.
    // Reglas de _titleOverride():
    //   - gana la clave MÁS LARGA (especificidad: "javascript" > "java",
    //     "azure devops" > "azure"), sin depender del orden de declaración;
    //   - la clave tiene que aparecer como token completo, así "git" no matchea
    //     "github" ni "digital", y "nv" no matchea "invoice".
    readonly property var title_map: {
        // Pestañas de Firefox (el título es el de la página, no el de la app).
        // Nota: los repos de GitHub casi nunca dicen "github" en el título;
        // este scope matchea lo que la página sí expone.
        "firefox": {
            "github":          { title: "GitHub",           icon: "" },
            "gitlab":          { title: "GitLab",           icon: "" },
            "bitbucket":       { title: "Bitbucket",        icon: "" },
            "amazon":          { title: "AWS",              icon: "" },
            "aws":             { title: "AWS",              icon: "" },
            "azure devops":    { title: "Azure DevOps",     icon: "" },
            "azure":           { title: "Azure",            icon: "" },
            "google cloud":    { title: "Google Cloud",     icon: "" },
            "cloudflare":      { title: "Cloudflare",       icon: "" },
            "digitalocean":    { title: "DigitalOcean",     icon: "" },
            "heroku":          { title: "Heroku",           icon: "" },
            "firebase":        { title: "Firebase",         icon: "" },
            "vercel":          { title: "Vercel",           icon: "" },
            "netlify":         { title: "Netlify",          icon: "" },
            "docker":          { title: "Docker",           icon: "" },
            "kubernetes":      { title: "Kubernetes",       icon: "" },
            "terraform":       { title: "Terraform",        icon: "" },
            "ansible":         { title: "Ansible",          icon: "" },
            "jenkins":         { title: "Jenkins",          icon: "" },
            "grafana":         { title: "Grafana",          icon: "" },
            "datadog":         { title: "Datadog",          icon: "" },
            "sentry":          { title: "Sentry",           icon: "" },
            "postman":         { title: "Postman",          icon: "" },
            "swagger":         { title: "Swagger",          icon: "" },
            "openapi":         { title: "OpenAPI",          icon: "󰅩" },
            "jira":            { title: "Jira",             icon: "" },
            "confluence":      { title: "Confluence",       icon: "" },
            "slack":           { title: "Slack",            icon: "" },
            "figma":           { title: "Figma",            icon: "" },
            "notion":          { title: "Notion",           icon: "" },
            "microsoft teams": { title: "Microsoft Teams",  icon: "󰊻" },
            "whatsapp":        { title: "WhatsApp",         icon: "󰖣" },
            "youtube":         { title: "YouTube",          icon: "" },
            "stack overflow":  { title: "Stack Overflow",   icon: "" },
            "hacker news":     { title: "Hacker News",      icon: "" },
            "microsoft learn": { title: "Microsoft Learn",  icon: "󰑴" },
            "mdn":             { title: "MDN",              icon: "" },
            "python":          { title: "Python",           icon: "" },
            "javascript":      { title: "JavaScript",       icon: "" },
            "typescript":      { title: "TypeScript",       icon: "" },
            "react":           { title: "React",            icon: "" },
            "vue":             { title: "Vue",              icon: "" },
            "angular":         { title: "Angular",          icon: "" },
            "java":            { title: "Java",             icon: "" },
            "rust":            { title: "Rust",             icon: "" },
            "dotnet":          { title: ".NET",             icon: "" },
            "node":            { title: "Node.js",          icon: "" },
            "kotlin":          { title: "Kotlin",           icon: "" },
            "swift":           { title: "Swift",            icon: "" },
            "php":             { title: "PHP",              icon: "" },
            "dart":            { title: "Dart",             icon: "" },
            "postgresql":      { title: "PostgreSQL",       icon: "" },
            "mysql":           { title: "MySQL",            icon: "" },
            "mongodb":         { title: "MongoDB",          icon: "" },
            "redis":           { title: "Redis",            icon: "" },
            "sqlite":          { title: "SQLite",           icon: "" }
        },
        // Terminales
        "kitty": {
            "nvim": { title: "Neovim",  icon: "" },
            "git":  { title: "Git",     icon: "" }
        },
        // Ventanas de agentes: kitty --class agent
        "agent": {
            "pi-":      { title: "pi Harness",   icon: "󰚩" },
            "claude":   { title: "Claude Code",  icon: "󱚝" },
            "opencode": { title: "OpenCode",     icon: "󱜙" },
            "oc | ":    { title: "OpenCode",     icon: "󱜙" }
        }
    }

    // appId -> scope de title_map
    readonly property var scope_map: {
        "org.mozilla.firefox": "firefox",
        "term.float":          "kitty"
    }

    function _escapeRe(text) {
        return text.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    }

    function _titleOverride(scope, title) {
        const entries = title_map[scope];
        if (!entries)
            return null;

        const needle = String(title).toLowerCase();
        const keys = Object.keys(entries);
        keys.sort((a, b) => b.length - a.length);

        for (let i = 0; i < keys.length; i++) {
            const key = keys[i].toLowerCase();
            const left = "(^|[^a-z0-9])" + _escapeRe(key);
            const right = /[a-z0-9]$/.test(key) ? "(?![a-z0-9])" : "";
            if (new RegExp(left + right).test(needle))
                return entries[keys[i]];
        }

        return null;
    }

    function getMatchById(appId) {
        if (!appId)
            return { title: "Desktop", icon: "󰇄" };

        const key = String(appId).toLowerCase();

        if (id_map[key] !== undefined)
            return id_map[key];

        // Muchos apps usan appId reverse-DNS: "md.obsidian.Obsidian" -> "obsidian"
        const lastSegment = key.slice(key.lastIndexOf(".") + 1);
        if (lastSegment !== key && id_map[lastSegment] !== undefined)
            return id_map[lastSegment];

        return { title: "Unknown", icon: "󰣆" };
    }

    function getMatch(appId, title) {
        const match = getMatchById(appId);
        const appKey = appId === undefined || appId === null ? "" : String(appId).toLowerCase();
        const scope = scope_map[appKey] !== undefined ? scope_map[appKey] : appKey;

        const override = title ? _titleOverride(scope, title) : null;
        if (!override)
            return { title: match.title, icon: match.icon };

        return {
            title: override.title !== undefined ? override.title : match.title,
            icon: override.icon !== undefined ? override.icon : match.icon
        };
    }
}
