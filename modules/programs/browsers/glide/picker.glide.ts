const HISTORY_LIMIT = 1000;

function makeUrlOption(title: string | undefined, url: string, extra?: string) {
    return {
        label: title?.trim() || url,
        description: extra ? `${url} · ${extra}` : url,

        async execute() {
            // 类似从原生书签/历史 UI 打开：替换当前 tab
            const tab = await glide.tabs.active();
            await browser.tabs.update(tab.id, { url });
        },
    };
}

const bookmarkCmd = glide.excmds.create(
    {
        name: "bookmark",
        description: "Open the bookmarks picker",
    },
    async () => {
        // search({}) 返回所有书签节点，包括文件夹，因此过滤 url
        const nodes = await browser.bookmarks.search({});

        const options = nodes.flatMap((node) => {
            const url = node.url;
            if (!url) return [];

            return [makeUrlOption(node.title, url)];
        });

        await glide.commandline.show({
            title: "Bookmarks",
            options,
        });
    },
);

const historyCmd = glide.excmds.create(
    {
        name: "history",
        description: "Open the history picker",
    },
    async () => {
        const items = await browser.history.search({
            text: "",
            startTime: 0,
            maxResults: HISTORY_LIMIT,
        });

        const options = items.flatMap((item) => {
            const url = item.url;
            if (!url) return [];

            const visited = item.lastVisitTime
                ? new Date(item.lastVisitTime).toLocaleString()
                : undefined;

            return [makeUrlOption(item.title, url, visited)];
        });

        await glide.commandline.show({
            title: "History",
            options,
        });
    },
);

declare global {
    interface ExcmdRegistry {
        bookmark: typeof bookmarkCmd;
        history: typeof historyCmd;
    }
}
