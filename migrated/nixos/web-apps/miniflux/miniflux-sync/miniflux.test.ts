import assert from "node:assert/strict";
import { once } from "node:events";
import { createServer } from "node:http";
import type { IncomingHttpHeaders } from "node:http";
import type { AddressInfo } from "node:net";
import { test } from "node:test";
import type { TestContext } from "node:test";
import { applyConfig, createClient } from "./miniflux.ts";
import type { Config } from "./miniflux.ts";

type Request = {
    method: string;
    path: string;
    headers: IncomingHttpHeaders;
    body: Record<string, unknown>;
};

async function mockApi(
    t: TestContext,
    handle: (request: Request) => { status?: number; body: unknown },
) {
    const requests: Request[] = [];
    const server = createServer(async (request, response) => {
        let text = "";
        for await (const chunk of request) text += chunk;
        const entry = {
            method: request.method!,
            path: request.url!,
            headers: request.headers,
            body: text ? JSON.parse(text) : {},
        };
        requests.push(entry);
        const result = handle(entry);
        response.writeHead(result.status ?? 200, {
            "Content-Type": "application/json",
        });
        response.end(JSON.stringify(result.body));
    });
    server.listen(0, "127.0.0.1");
    await once(server, "listening");
    t.after(
        () =>
            new Promise<void>((resolve, reject) => {
                server.close((error) => (error ? reject(error) : resolve()));
            }),
    );
    const { port } = server.address() as AddressInfo;
    return { url: `http://127.0.0.1:${port}/miniflux/`, requests };
}

test("resolves categories, creates new feeds and updates existing feeds on repeated runs", async (t) => {
    const categories = [{ id: 7, title: "Existing" }];
    const feeds = [{ id: 1, feed_url: "https://example.org/existing.xml" }];
    const api = await mockApi(t, ({ method, path, body }) => {
        if (path.endsWith("/categories")) {
            if (method === "GET") return { body: categories };
            const category = {
                id: categories.length + 7,
                title: body.title as string,
            };
            categories.push(category);
            return { status: 201, body: category };
        }
        if (method === "GET") return { body: feeds };
        if (method === "PUT") {
            const feed = feeds.find((feed) =>
                path.endsWith(`/feeds/${feed.id}`),
            );
            if (!feed)
                return {
                    status: 404,
                    body: { error_message: "Feed not found" },
                };
            Object.assign(feed, body);
            return { body: feed };
        }
        const feed = {
            id: feeds.length + 1,
            feed_url: body.feed_url as string,
        };
        feeds.push(feed);
        return { status: 201, body: { feed_id: feed.id } };
    });
    const rules = {
        crawler: true,
        scraper_rules: "article",
        rewrite_rules: 'remove(".advert")',
        blocklist_rules: "advertisement",
        keeplist_rules: "typescript",
    };
    const config: Config = {
        categories: ["Empty"],
        feeds: [
            {
                feed_url: "https://example.org/existing.xml",
                category: "New",
                ...rules,
            },
            {
                feed_url: "https://example.org/one.xml",
                category: "New",
                ...rules,
            },
            { feed_url: "https://example.org/two.xml", category: "New" },
            { feed_url: "https://example.org/two.xml", category: "New" },
            { feed_url: "https://example.org/three.xml", category: "Existing" },
        ],
    };
    const logs: string[] = [];
    await applyConfig(createClient(api.url, "test-token"), config, (line) =>
        logs.push(line),
    );
    await applyConfig(createClient(api.url, "test-token"), config, (line) =>
        logs.push(line),
    );

    const posts = api.requests.filter((request) => request.method === "POST");
    assert.deepEqual(
        posts.map((request) => request.body),
        [
            { title: "Empty" },
            { title: "New" },
            {
                feed_url: "https://example.org/one.xml",
                ...rules,
                category_id: 9,
            },
            { feed_url: "https://example.org/two.xml", category_id: 9 },
            { feed_url: "https://example.org/three.xml", category_id: 7 },
        ],
    );
    const updates = api.requests.filter((request) => request.method === "PUT");
    assert.deepEqual(
        updates.map(({ path, body }) => ({ path, body })),
        [
            {
                path: "/miniflux/v1/feeds/1",
                body: {
                    feed_url: config.feeds[0]!.feed_url,
                    ...rules,
                    category_id: 9,
                },
            },
            {
                path: "/miniflux/v1/feeds/1",
                body: {
                    feed_url: config.feeds[0]!.feed_url,
                    ...rules,
                    category_id: 9,
                },
            },
            {
                path: "/miniflux/v1/feeds/2",
                body: {
                    feed_url: config.feeds[1]!.feed_url,
                    ...rules,
                    category_id: 9,
                },
            },
            {
                path: "/miniflux/v1/feeds/3",
                body: { feed_url: config.feeds[2]!.feed_url, category_id: 9 },
            },
            {
                path: "/miniflux/v1/feeds/4",
                body: { feed_url: config.feeds[4]!.feed_url, category_id: 7 },
            },
        ],
    );
    assert.equal(api.requests.filter((r) => r.method === "GET").length, 4);
    assert.equal(logs.filter((line) => line.startsWith("Created")).length, 3);
    assert.equal(logs.filter((line) => line.startsWith("Updated")).length, 5);
    assert.equal(
        logs.filter((line) => line.startsWith("Skipped duplicate")).length,
        2,
    );
    for (const request of api.requests) {
        assert.equal(request.headers["x-auth-token"], "test-token");
        assert.ok(request.path.startsWith("/miniflux/v1/"));
    }
});

test("createFeed resolves and caches categories without exposing category IDs in its input", async (t) => {
    const api = await mockApi(t, ({ path }) => ({
        body: path.endsWith("/categories")
            ? [{ id: 42, title: "News" }]
            : { feed_id: 12 },
    }));
    const client = createClient(api.url, "test-token");
    const feed = { feed_url: "https://example.org/feed.xml", category: "News" };
    assert.deepEqual(await client.createFeed(feed), { feed_id: 12 });
    await client.createFeed(feed);
    assert.equal(api.requests.length, 3);
    assert.deepEqual(api.requests[1]!.body, {
        feed_url: feed.feed_url,
        category_id: 42,
    });
});

test("stops at the first API error and includes the endpoint and status", async (t) => {
    const api = await mockApi(t, ({ method, path }) => {
        if (path.endsWith("/categories"))
            return { body: [{ id: 1, title: "News" }] };
        if (method === "GET") return { body: [] };
        return { status: 400, body: { error_message: "Invalid feed" } };
    });
    await assert.rejects(
        applyConfig(createClient(api.url, "test-token"), {
            feeds: [
                { feed_url: "https://example.org/bad.xml", category: "News" },
                { feed_url: "https://example.org/later.xml", category: "News" },
            ],
        }),
        /Could not create feed .*bad.xml: POST \/v1\/feeds: HTTP 400 .*Invalid feed/,
    );
    assert.equal(
        api.requests.filter((request) => request.method === "POST").length,
        1,
    );
});

test("updates only supplied fields and preserves explicit empty rules and false", async (t) => {
    const api = await mockApi(t, ({ method, path }) => {
        if (path.endsWith("/categories"))
            return { body: [{ id: 42, title: "News" }] };
        if (method === "GET")
            return {
                body: [{ id: 12, feed_url: "https://example.org/feed.xml" }],
            };
        return { body: { id: 12 } };
    });
    await applyConfig(
        createClient(api.url, "test-token"),
        {
            feeds: [
                {
                    feed_url: "https://example.org/feed.xml",
                    category: "News",
                    crawler: false,
                    scraper_rules: "",
                    rewrite_rules: undefined,
                },
            ],
        },
        () => {},
    );
    const updates = api.requests.filter((request) => request.method === "PUT");
    assert.equal(updates.length, 1);
    assert.equal(updates[0]!.path, "/miniflux/v1/feeds/12");
    assert.deepEqual(updates[0]!.body, {
        feed_url: "https://example.org/feed.xml",
        category_id: 42,
        crawler: false,
        scraper_rules: "",
    });
    assert.equal(
        api.requests.filter((request) => request.method === "POST").length,
        0,
    );
});

test("stops at an update error without creating a replacement or processing later feeds", async (t) => {
    const api = await mockApi(t, ({ method, path }) => {
        if (path.endsWith("/categories"))
            return { body: [{ id: 1, title: "News" }] };
        if (method === "GET")
            return {
                body: [{ id: 12, feed_url: "https://example.org/feed.xml" }],
            };
        return { status: 403, body: { error_message: "Forbidden" } };
    });
    const logs: string[] = [];
    await assert.rejects(
        applyConfig(
            createClient(api.url, "test-token"),
            {
                feeds: [
                    {
                        feed_url: "https://example.org/feed.xml",
                        category: "News",
                    },
                    {
                        feed_url: "https://example.org/later.xml",
                        category: "News",
                    },
                ],
            },
            (line) => logs.push(line),
        ),
        /Could not update feed .*feed.xml: PUT \/v1\/feeds\/12: HTTP 403 .*Forbidden/,
    );
    assert.equal(
        api.requests.filter((request) => request.method === "PUT").length,
        1,
    );
    assert.equal(
        api.requests.filter((request) => request.method === "POST").length,
        0,
    );
    assert.deepEqual(logs, []);
});

test("rejects invalid configuration before making requests", async (t) => {
    const api = await mockApi(t, () => ({ body: [] }));
    const client = createClient(api.url, "test-token");
    await assert.rejects(
        applyConfig(client, { categories: [" "], feeds: [] }),
        /blank/,
    );
    await assert.rejects(
        applyConfig(client, {
            feeds: [{ feed_url: "file:///tmp/feed.xml", category: "News" }],
        }),
        /HTTP\(S\)/,
    );
    await applyConfig(client, { feeds: [] });
    assert.equal(api.requests.length, 0);
    assert.throws(() => createClient(api.url, " "));
    assert.throws(
        () => createClient(`${api.url}?query=1`, "token"),
        /query or fragment/,
    );
});
