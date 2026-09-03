const opts = glide.o;
opts.native_tabs = "autohide";
opts.switch_mode_on_focus = true;

opts.go_next_patterns = opts.go_next_patterns.concat(["下一页"]);
opts.go_previous_patterns = opts.go_previous_patterns.concat(["上一页"]);

glide.keymaps.set("normal", "d", "scroll_half_page_down");
glide.keymaps.set("normal", "e", "scroll_half_page_up");
glide.keymaps.set("normal", "J", "scroll_half_page_down");
glide.keymaps.set("normal", "K", "scroll_half_page_up");
glide.keymaps.set("normal", "<leader>r", "config_reload");
glide.keymaps.set(["normal", "insert"], "<A-x>", "commandline_toggle"); // M-x

async function copyToClipboard(text: string) {
    await navigator.clipboard.writeText(text);
    await browser.notifications.create({
        type: "basic",
        title: "Copied to clipboard",
        message: text,
    });
}

async function copyFlakeGHFormat(tab_id: number, lead: string) {
    // should work for forgejo, codeberg, gitlab (ideally)
    const url = (await browser.tabs.get(tab_id)).url?.split("/");
    if (url !== undefined && url[3] !== undefined && url[4] !== undefined) {
        // we want split 4 and 5
        const flakeUrl = lead.concat(":", url[3], "/", url[4]);
        await copyToClipboard(flakeUrl);
    }
}

async function copyGHShortId(tab: number) {
    const url = (await browser.tabs.get(tab)).url?.split("/");
    if (url !== undefined && url[3] !== undefined && url[4] !== undefined) {
        // we want split 4 and 5
        const shortId = `${url[3]}/${url[4]}`;
        await copyToClipboard(shortId);
    }
}
async function tabToNewWindow() {
    const tab = await glide.tabs.active();

    if (!tab.url) {
        throw new Error("Active tab has no accessible URL");
    }

    await browser.windows.create({
        focused: true,
        url: tab.url,
    });
}

async function exportCurrentTabCookies(): Promise<void> {
    const tab = await glide.tabs.active();

    if (!tab.url) {
        throw new Error("Current tab has no accessible URL");
    }

    const url = new URL(tab.url);

    if (url.protocol !== "http:" && url.protocol !== "https:") {
        throw new Error(`Cannot export cookies for ${url.protocol} URLs`);
    }

    const cookies = await browser.cookies.getAll({
        url: url.href,
        ...(tab.cookieStoreId ? { storeId: tab.cookieStoreId } : {}),
    });

    await copyToClipboard(JSON.stringify(cookies, null, 2));
}

// copy flake urls
glide.autocmds.create(
    "UrlEnter",
    {
        hostname: "github.com",
    },
    async ({ tab_id }) => {
        glide.buf.keymaps.set("normal", ",F", async () => {
            await copyFlakeGHFormat(tab_id, "github");
        });
        glide.buf.keymaps.set("normal", ",y", async () => {
            await copyGHShortId(tab_id);
        });
    },
);

glide.excmds.create({ name: "tab_bar_toggle" }, () => {
    if (opts.native_tabs == "autohide") {
        opts.native_tabs = "show";
    } else {
        opts.native_tabs = "autohide";
    }
});

glide.excmds.create(
    {
        name: "tab_to_window",
        description: "create new window with current tab",
    },
    () => tabToNewWindow(),
);
glide.keymaps.set("normal", "W", tabToNewWindow);
glide.excmds.create(
    {
        name: "copy_cookies",
        description: "Copy cookies of current site to clipboard",
    },
    () => exportCurrentTabCookies(),
);

glide.include("./search-engines.glide.ts");
glide.include("./excmd-alias.glide.ts");
glide.include("./picker.glide.ts");
