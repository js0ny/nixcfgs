import { mkdtemp, rm } from "node:fs/promises";
import { tmpdir as systemTmpdir } from "node:os";
import { join } from "node:path";
import { StringEnum, Type } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

type Lifetime = "turn" | "session";

export default function tmpdirExtension(pi: ExtensionAPI) {
    const turnDirs = new Set<string>();
    const sessionDirs = new Set<string>();

    async function cleanup(dirs: Set<string>): Promise<void> {
        await Promise.allSettled(
            [...dirs].map(async (dir) => {
                await rm(dir, { recursive: true, force: true });
                dirs.delete(dir);
            }),
        );
    }

    pi.registerTool({
        name: "tmpdir",
        label: "Temporary Directory",
        description:
            "Create a private temporary directory for disposable experiments. " +
            "It is removed automatically when the agent settles, or at session shutdown when lifetime is session.",
        promptSnippet:
            "Create an automatically cleaned temporary directory for disposable experiments",
        promptGuidelines: [
            "Use tmpdir instead of mktemp -d for disposable experiments; tmpdir directories are cleaned automatically, so do not delete them manually.",
        ],
        parameters: Type.Object({
            lifetime: Type.Optional(
                StringEnum(["turn", "session"] as const, {
                    description:
                        "How long to keep the directory: until the agent settles (turn, default) or until session shutdown (session)",
                    default: "turn",
                }),
            ),
        }),
        async execute(_toolCallId, params) {
            const lifetime: Lifetime = params.lifetime ?? "turn";
            const dir = await mkdtemp(join(systemTmpdir(), "pi-tmpdir-"));
            (lifetime === "turn" ? turnDirs : sessionDirs).add(dir);

            return {
                content: [{ type: "text", text: dir }],
                details: { path: dir, lifetime },
            };
        },
    });

    pi.on("agent_settled", async () => {
        await cleanup(turnDirs);
    });

    pi.on("session_shutdown", async () => {
        await Promise.all([cleanup(turnDirs), cleanup(sessionDirs)]);
    });
}
