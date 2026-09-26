type SearchEngine = {
    name: string;
    keyword?: string | string[];
    search_url: string;
    favicon_url?: string;
};
const searchEngines: SearchEngine[] = [
    {
        name: "AlternativeTo",
        keyword: "a2",
        search_url: "https://alternativeto.net/browse/search/?q={searchTerms}",
        favicon_url: "https://alternativeto.net/favicon.ico",
    },
    {
        name: "ArchLinux Packages",
        keyword: ["pac", "pacman"],
        search_url: "https://archlinux.org/packages/?q={searchTerms}",
        favicon_url: "https://archlinux.org/favicon.ico",
    },
    {
        name: "ArchWiki",
        keyword: "aw",
        search_url: "https://wiki.archlinux.org/index.php?search={searchTerms}",
        favicon_url: "https://archlinux.org/favicon.ico",
    },
    {
        name: "Arch User Repository",
        keyword: ["aur", "yay", "paru"],
        search_url: "https://aur.archlinux.org/packages?K={searchTerms}",
        favicon_url: "https://archlinux.org/favicon.ico",
    },
    {
        name: "ChatGPT",
        keyword: ["gpt", "chatgpt"],
        search_url: "https://chatgpt.com/?q={searchTerms}",
        favicon_url: "https://chatgpt.com/favicon.ico",
    },
    {
        name: "Codeberg",
        keyword: ["@codeberg"],
        search_url: "https://codeberg.org/explore/repos?q={searchTerms}",
        favicon_url: "https://codeberg.org/favicon.ico",
    },
    {
        name: "crates",
        keyword: ["@cr"],
        search_url: "https://crates.io/search?q={searchTerms}",
        favicon_url: "https://www.nuget.org/favicon.ico",
    },
    {
        name: "Fedora Packages",
        keyword: "dnf",
        search_url:
            "https://packages.fedoraproject.org/search?query={searchTerms}",
        favicon_url: "https://fedoraproject.org/favicon.ico",
    },
    {
        name: "Flathub",
        keyword: ["@flatpak", "@flathub"],
        search_url: "https://flathub.org/apps/search?q={searchTerms}",
        favicon_url: "https://flathub.org/favicon.ico",
    },
    {
        name: "GitHub Repository",
        keyword: ["gh", "ghr", "github"],
        search_url:
            "https://github.com/search?type=repositories&q={searchTerms}",
        favicon_url: "https://github.com/favicon.ico",
    },
    {
        name: "Grok",
        keyword: "grok",
        search_url: "https://grok.com/?q={searchTerms}",
        favicon_url: "https://grok.com/favicon.ico",
    },
    {
        name: "Home Manager Options",
        keyword: "hm",
        search_url:
            "https://home-manager-options.extranix.com/?query={searchTerms}&release=master",
        favicon_url: "https://nixos.org/favicon.ico",
    },
    {
        name: "Nix Options",
        keyword: ["@no", "nixopt"],
        search_url:
            "https://search.nixos.org/options?channel=unstable&query={searchTerms}",
        favicon_url: "https://nixos.org/favicon.ico",
    },
    {
        name: "Nix Packages",
        keyword: ["np", "nixpkg"],
        search_url:
            "https://search.nixos.org/packages?channel=unstable&query={searchTerms}",
        favicon_url: "https://nixos.org/favicon.ico",
    },
    {
        name: "noogλe",
        keyword: ["noogle", "@nixl"],
        search_url: "https://noogle.dev/q/?term={searchTerms}",
        favicon_url: "https://noogle.dev/favicon.ico",
    },
    {
        name: "NuGet",
        keyword: ["@nuget"],
        search_url: "https://www.nuget.org/packages?q={searchTerms}",
        favicon_url: "https://www.nuget.org/favicon.ico",
    },
    {
        name: "PCGamingWiki",
        keyword: ["@pcgw"],
        search_url:
            "https://www.pcgamingwiki.com/w/index.php?search={searchTerms}",
    },
    {
        name: "Perplexity",
        keyword: "pplx",
        search_url: "https://www.perplexity.ai/?q={searchTerms}",
        favicon_url: "https://perplexity.ai/favicon.ico",
    },
    {
        name: "PyPi",
        keyword: ["py", "pypi"],
        search_url: "https://pypi.org/search/?q={searchTerms}",
        favicon_url: "https://pypi.org/favicon.ico",
    },
    {
        name: "Repology",
        keyword: ["repo", "repology"],
        search_url: "https://repology.org/projects/?search={searchTerms}",
        favicon_url: "https://repology.org/favicon.ico",
    },
    {
        name: "scoop",
        keyword: ["sc", "scoop"],
        search_url: "https://scoop.sh/#/apps?q={searchTerms}",
        favicon_url: "https://scoop.sh/favicon.ico",
    },
    {
        name: "Searchix",
        keyword: "searchix",
        search_url: "https://searchix.ovh/?query={searchTerms}",
        favicon_url: "https://searchix.ovh/favicon.ico",
    },
    {
        name: "SearXNG",
        keyword: ["sx", "searxng"],
        search_url: "https://searx.js0ny.net?q={searchTerms}",
        favicon_url: "https://searx.js0ny.net/favicon.ico",
    },
    {
        name: "Windows Package Manager",
        keyword: ["win", "winget"],
        search_url: "https://winget.ragerworks.com/search/all/{searchTerms}",
        favicon_url: "https://microsoft.com/favicon.ico",
    },
    {
        name: "Youtube",
        keyword: ["yt", "youtube"],
        search_url:
            "https://www.youtube.com/results?search_query={searchTerms}",
        favicon_url: "https://youtube.com/favicon.ico",
    },
];

for (const searchEngine of searchEngines) {
    glide.search_engines.add(searchEngine);
}
