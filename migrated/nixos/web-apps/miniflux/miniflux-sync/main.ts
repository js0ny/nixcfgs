import { readFile } from "node:fs/promises";
import { applyConfig, createClient } from "./miniflux.ts";
import type { Config } from "./miniflux.ts";

try {
    const url = process.env.MINIFLUX_URL?.trim();
    const tokenFile = process.env.MINIFLUX_API_TOKEN_FILE;
    const configFile = process.env.MINIFLUX_CONFIG_FILE;
    if (!url || !tokenFile || !configFile) {
        throw new Error(
            "Set MINIFLUX_URL, MINIFLUX_API_TOKEN_FILE and MINIFLUX_CONFIG_FILE in environment",
        );
    }
    const token = (await readFile(tokenFile, "utf8")).trim();
    const config: Config = JSON.parse(await readFile(configFile, "utf8"));
    await applyConfig(createClient(url, token), config);
} catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    process.exitCode = 1;
}
