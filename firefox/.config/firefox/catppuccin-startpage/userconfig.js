// latte / frappe / macchiato / mocha
const palette = mocha;

const default_config = {
  overrideStorage: true,
  temperature: {
    location: "Buenos Aires",
    scale: "C",
  },
  clock: {
    format: "h:i p",
    iconColor: palette.maroon,
  },
  disabled: [],
  openLastVisitedTab: true,
  tabs: [
    {
      name: "work",
      background_url: "src/img/banners/cbg-05.gif",
      categories: [
        {
          name: "itba",
          links: [
            {
              name: "campus",
              url: "https://campus.itba.edu.ar/ultra/stream",
              icon: "books",
              icon_color: palette.green,
            },
            {
              name: "sga",
              url: "https://sga.itba.edu.ar",
              icon: "device-ipad-horizontal-cog",
              icon_color: palette.blue
            },
            {
              name: "azure-ai",
              url: "https://learn.microsoft.com/es-mx/training/courses/ai-102t00",
              icon_color: palette.red,
              icon: "brand-azure"
            }
          ],
        },
        {
          name: "workspace",
          links: [
            {
              name: "gmail",
              url: "https://mail.google.com",
              icon: "brand-gmail",
              icon_color: palette.green,
            },
            {
              name: "drive",
              url: "https://drive.google.com/drive/home",
              icon: "brand-google-drive",
              icon_color: palette.blue,
            },
            {
              name: "overleaf",
              url: "https:/overleaf.cuini.me",
              icon: "tex",
              icon_color: palette.peach,
            },
          ],
        },
        {
          name: "tools",
          links: [
            {
              name: "whatsapp",
              url: "https://web.whatsapp.com",
              icon: "brand-whatsapp",
              icon_color: palette.green,
            },
          ],
        },
      ],
    },
    {
      name: "dev",
      background_url: "src/img/banners/cbg-06.gif",
      categories: [
        {
          name: "development",
          links: [
            {
              name: "github",
              url: "https://github.com",
              icon: "brand-github",
              icon_color: palette.green,
            },
            {
              name: "bitbucket",
              url: "https://home.atlassian.com/",
              icon: "brand-bitbucket",
              icon_color: palette.blue,
            },
            {
              name: "chatgpt",
              url: "https://chatgpt.com",
              icon: "brand-openai",
              icon_color: palette.peach,
            },
            {
              name: "stackoverflow",
              url: "https://stackoverflow.com",
              icon: "brand-stackoverflow",
              icon_color: palette.red,
            },
          ],
        },
        {
          name: "challenges",
          links: [
            {
              name: "kaggle",
              url: "https://www.kaggle.com",
              icon: "brain",
              icon_color: palette.green,
            },
            {
              name: "leetcode",
              url: "https://leetcode.com",
              icon: "code-plus",
              icon_color: palette.peach,
            },
            {
              name: "exercism",
              url: "https://exercism.org",
              icon: "code-minus",
              icon_color: palette.red,
            },
            {
              name: "aoc",
              url: "https://adventofcode.com",
              icon: "brand-linktree",
              icon_color: palette.blue,
            },
          ],
        },
        {
          name: "resources",
          links: [
            {
              name: "music",
              url: "https://musicforprogramming.net",
              icon: "binary-tree",
              icon_color: palette.green,
            },
            {
              name: "hackernews",
              url: "https://news.ycombinator.com",
              icon: "brand-redhat",
              icon_color: palette.peach,
            },
            {
              name: "uber blog",
              url: "https://www.uber.com/en-GB/blog/london/engineering",
              icon: "brand-uber",
              icon_color: palette.red,
            },
            {
              name: "netflix blog",
              url: "https://netflixtechblog.com",
              icon: "brand-netflix",
              icon_color: palette.blue,
            },

          ],
        },
      ],
    },
    {
      name: "chi ll",
      background_url: "src/img/banners/cbg-01.gif",
      categories: [
        {
          name: "social media",
          links: [
            {
              name: "twitter",
              url: "https://twitter.com",
              icon: "brand-twitter",
              icon_color: palette.blue,
            },
            {
              name: "instagram",
              url: "https://www.instagram.com",
              icon: "brand-instagram",
              icon_color: palette.red,
            },
            {
              name: "reddit",
              url: "https://www.reddit.com",
              icon: "brand-reddit",
              icon_color: palette.peach,
            },
            {
              name: "promiedos",
              url: "https://www.promiedos.com.ar",
              icon: "ball-football",
              icon_color: palette.green,
            },
          ],
        },
        {
          name: "gaming",
          links: [
            {
              name: "twitch",
              url: "https://twitch.tv",
              icon: "brand-twitch",
              icon_color: palette.lavender,
            },
            {
              name: "kick",
              url: "https://kick.com/Vonfre",
              icon: "brand-kick",
              icon_color: palette.green,
            },
            {
              name: "steam",
              url: "https://store.steampowered.com",
              icon: "brand-steam",
              icon_color: palette.red,
            },
            {
              name: "lol",
              url: "https://mobalytics.gg/lol/tier-list",
              icon: "device-gamepad",
              icon_color: palette.blue,
            },
          ],
        },
        {
          name: "video",
          links: [
            {
              name: "youtube",
              url: "https://www.youtube.com",
              icon: "brand-youtube",
              icon_color: palette.red,
            },
            {
              name: "flow",
              url: "https://www.flow.com.ar",
              icon: "player-play",
              icon_color: palette.green,
            },

            {
              name: "disney+",
              url: "https://www.disneyplus.com",
              icon: "brand-disney",
              icon_color: palette.red,
            },
          ],
        },
      ],
    },
  ],
};

const CONFIG = new Config(default_config, palette);

const root = document.querySelector(":root");
root.style.setProperty("--bg", palette.mantle);
root.style.setProperty("--accent", palette.green);
