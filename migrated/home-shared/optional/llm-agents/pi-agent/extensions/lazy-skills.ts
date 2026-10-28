// Discovers configured skills when their environment variable or file condition is met.
// /lazy-skill <name-or-directory> [request] loads a skill regardless of its condition.
import { existsSync, readdirSync, readFileSync } from "node:fs";
import { readFile } from "node:fs/promises";
import { homedir } from "node:os";
import { dirname, join, resolve } from "node:path";
import {
    getAgentDir,
    type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

type Rule = { env: string; skill: string } | { file: string; skill: string };

const defaultRules: Rule[] = [{ env: "HERDR_ENV", skill: "herdr" }];

function skillPath(name: string): string {
    const directory = name.startsWith("/")
        ? name
        : name === "~" || name.startsWith("~/")
          ? join(homedir(), name.slice(1))
          : join(getAgentDir(), "lazy-skills", name);
    return join(directory, "SKILL.md");
}

function readRules(path: string): Rule[] {
    let content: string;
    try {
        content = readFileSync(path, "utf8");
    } catch (error) {
        if ((error as NodeJS.ErrnoException).code === "ENOENT") return [];
        throw error;
    }

    const rules: unknown = JSON.parse(content);
    if (
        !Array.isArray(rules) ||
        !rules.every(
            (rule) =>
                rule !== null &&
                typeof rule === "object" &&
                typeof rule.skill === "string" &&
                ((typeof rule.env === "string" && rule.file === undefined) ||
                    (typeof rule.file === "string" && rule.env === undefined)),
        )
    ) {
        throw new Error(`Invalid lazy skill rules in ${path}`);
    }
    return rules;
}

export default function lazySkills(pi: ExtensionAPI) {
    let rules = defaultRules;
    pi.on("resources_discover", (_event, ctx) => {
        const paths = new Set([
            join(getAgentDir(), "lazy-skills.json"),
            resolve(ctx.cwd, "lazy-skills.json"),
        ]);
        rules = [...defaultRules, ...[...paths].flatMap(readRules)];
        return {
            skillPaths: [
                ...new Set(
                    rules
                        .filter((rule) =>
                            "env" in rule
                                ? process.env[rule.env] === "1"
                                : existsSync(resolve(ctx.cwd, rule.file)),
                        )
                        .map(({ skill }) => skillPath(skill)),
                ),
            ],
        };
    });

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
