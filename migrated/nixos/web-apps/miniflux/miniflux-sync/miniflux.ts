export type FeedConfig = {
    feed_url: string;
    category: string;
    crawler?: boolean;
    scraper_rules?: string;
    rewrite_rules?: string;
    blocklist_rules?: string;
    keeplist_rules?: string;
};

export type Config = {
    categories?: string[];
    feeds: FeedConfig[];
};

type Category = { id: number; title: string };
type Feed = { id: number; feed_url: string };

function httpUrl(value: string): URL {
    const url = new URL(value);
    if (
        !["http:", "https:"].includes(url.protocol) ||
        url.username ||
        url.password
    ) {
        throw new Error("URLs must use HTTP(S) without embedded credentials.");
    }
    return url;
}

export function createClient(baseUrl: string, token: string) {
    const base = httpUrl(baseUrl);
    if (base.search || base.hash) {
        throw new Error("MINIFLUX_URL must not contain a query or fragment.");
    }
    if (!token.trim()) throw new Error("API token must not be blank.");
    base.pathname = `${base.pathname.replace(/\/+$/, "")}/`;
    let categories: Map<string, number> | undefined;

    async function request<T>(
        path: string,
        method: "GET" | "POST" | "PUT" = "GET",
        body?: unknown,
    ): Promise<T> {
        const response = await fetch(new URL(`v1/${path}`, base), {
            method,
            headers: {
                "X-Auth-Token": token,
                Accept: "application/json",
                ...(body === undefined
                    ? {}
                    : { "Content-Type": "application/json" }),
            },
            body: body === undefined ? undefined : JSON.stringify(body),
            // Do not forward the API token to a redirect target.
            redirect: "error",
            signal: AbortSignal.timeout(60_000),
        });
        if (!response.ok) {
            throw new Error(
                `${method} /v1/${path}: HTTP ${response.status} ${await response.text()}`,
            );
        }
        return (await response.json()) as T;
    }

    async function getCategories(): Promise<Category[]> {
        const result = await request<Category[]>("categories");
        categories = new Map(result.map(({ title, id }) => [title, id]));
        return result;
    }

    async function createCategory(title: string): Promise<Category> {
        if (!title.trim()) throw new Error("Category names must not be blank.");
        const category = await request<Category>("categories", "POST", {
            title,
        });
        categories?.set(category.title, category.id);
        return category;
    }

    async function ensureCategory(title: string): Promise<number> {
        if (!categories) await getCategories();
        return categories!.get(title) ?? (await createCategory(title)).id;
    }

    async function createFeed(feed: FeedConfig): Promise<{ feed_id: number }> {
        const { category, ...fields } = feed;
        return request("feeds", "POST", {
            ...fields,
            category_id: await ensureCategory(category),
        });
    }

    async function updateFeed(id: number, feed: FeedConfig): Promise<Feed> {
        const { category, ...fields } = feed;
        return request(`feeds/${id}`, "PUT", {
            ...fields,
            category_id: await ensureCategory(category),
        });
    }

    return {
        getCategories,
        createCategory,
        ensureCategory,
        createFeed,
        updateFeed,
        getFeeds: () => request<Feed[]>("feeds"),
    };
}

export async function applyConfig(
    client: ReturnType<typeof createClient>,
    config: Config,
    log: (message: string) => void = console.log,
): Promise<void> {
    const titles = new Set([
        ...(config.categories ?? []),
        ...config.feeds.map((feed) => feed.category),
    ]);
    for (const title of titles) {
        if (!title.trim()) throw new Error("Category names must not be blank.");
    }
    for (const feed of config.feeds) httpUrl(feed.feed_url);
    if (!titles.size && !config.feeds.length) return;

    await client.getCategories();
    const existing = new Map(
        (await client.getFeeds()).map((feed) => [feed.feed_url, feed.id]),
    );
    for (const title of titles) await client.ensureCategory(title);

    const processed = new Set<string>();
    for (const feed of config.feeds) {
        if (processed.has(feed.feed_url)) {
            log(`Skipped duplicate feed: ${feed.feed_url}`);
            continue;
        }
        const id = existing.get(feed.feed_url);
        try {
            if (id === undefined) {
                await client.createFeed(feed);
            } else {
                await client.updateFeed(id, feed);
            }
        } catch (error) {
            throw new Error(
                `Could not ${id === undefined ? "create" : "update"} feed ${feed.feed_url}: ${(error as Error).message}`,
            );
        }
        processed.add(feed.feed_url);
        log(
            `${id === undefined ? "Created" : "Updated"} feed: ${feed.feed_url} [${feed.category}]`,
        );
    }
}
