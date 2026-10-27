// Discovers configured skills when their environment variables are set to "1".
// /lazy-skill <name-or-directory> [request] loads a skill regardless of its condition.
import { existsSync, readdirSync } from "node:fs";
import { readFile } from "node:fs/promises";
import { homedir } from "node:os";
import { dirname, join } from "node:path";
import {
    getAgentDir,
    type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

const rules = [
    { env: "HERDR_ENV", skill: "herdr" },
    { env: "TTY7", skill: "tty7" },
];

function skillPath(name: string): string {
    const directory = name.startsWith("/")
        ? name
        : name === "~" || name.startsWith("~/")
          ? join(homedir(), name.slice(1))
          : join(getAgentDir(), "lazy-skills", name);
    return join(directory, "SKILL.md");
}

export default function lazySkills(pi: ExtensionAPI) {
    pi.on("resources_discover", () => ({
        skillPaths: rules
            .filter(({ env }) => process.env[env] === "1")
            .map(({ skill }) => skillPath(skill)),
    }));

    pi.registerCommand("lazy-skill", {
        description: "Load a lazy skill: /lazy-skill <name> [request]",
        getArgumentCompletions: (prefix) => {
            if (/\s/.test(prefix)) return null;

            let names: string[];
            try {
                names = readdirSync(join(getAgentDir(), "lazy-skills"));
            } catch (error) {
                if ((error as NodeJS.ErrnoException).code !== "ENOENT")
                    throw error;
                names = [];
            }

            const candidates = new Set([
                ...names,
                ...rules.map(({ skill }) => skill),
            ]);
            const matches = [...candidates]
                .filter(
                    (name) =>
                        name.startsWith(prefix) && existsSync(skillPath(name)),
                )
                .sort()
                .map((name) => ({ value: name, label: name }));
            return matches.length ? matches : null;
        },
        handler: async (args, ctx) => {
            const match = args.trim().match(/^(\S+)(?:\s+([\s\S]*))?$/);
            if (!match) {
                ctx.ui.notify("Usage: /lazy-skill <name> [request]", "error");
                return;
            }

            const [, name, request] = match;
            const path = skillPath(name);
            let content: string;
            try {
                content = await readFile(path, "utf8");
            } catch (error) {
                ctx.ui.notify(
                    `Cannot load skill ${name}: ${String(error)}`,
                    "error",
                );
                return;
            }

            pi.sendUserMessage(
                `Follow the skill instructions below. Resolve relative paths from ${dirname(path)}.\n\n${content}${request ? `\n\n${request}` : ""}`,
                ctx.isIdle() ? undefined : { deliverAs: "followUp" },
            );
        },
    });
}
