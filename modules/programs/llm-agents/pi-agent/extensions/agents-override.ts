import { readFile } from "node:fs/promises";
import { join, resolve } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const OVERRIDE_FILE = "AGENTS.override.md";

function isMissingFile(error: unknown): boolean {
    return (error as NodeJS.ErrnoException).code === "ENOENT";
}

function appendProjectContext(systemPrompt: string, path: string, content: string): string {
    const instructions = `<project_instructions path="${path}">\n${content}\n</project_instructions>`;
    const closingTag = "\n</project_context>";
    const contextEnd = systemPrompt.lastIndexOf(closingTag);

    if (contextEnd >= 0) {
        return `${systemPrompt.slice(0, contextEnd)}\n\n${instructions}${systemPrompt.slice(contextEnd)}`;
    }

    return `${systemPrompt}\n\n<project_context>\n\nProject-specific override instructions and guidelines:\n\n${instructions}\n\n</project_context>`;
}

export default function agentsOverride(pi: ExtensionAPI) {
    pi.on("before_agent_start", async (event, ctx) => {
        const path = join(ctx.cwd, OVERRIDE_FILE);
        let content: string;

        try {
            content = await readFile(path, "utf8");
        } catch (error) {
            if (isMissingFile(error)) return;
            throw error;
        }

        if (!content.trim()) return;

        const contextFiles = event.systemPromptOptions.contextFiles ?? [];
        if (contextFiles.some((file) => resolve(file.path) === resolve(path))) return;

        event.systemPromptOptions.contextFiles = [...contextFiles, { path, content }];
        return { systemPrompt: appendProjectContext(event.systemPrompt, path, content) };
    });
}

