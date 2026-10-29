//
// Copyright: github @xddxdd

// Blocks commands referencing secret paths or passing `/` or `/nix/store(/)`
// as a single argument. Multi-line commands skip the root and store checks.

import { homedir } from "node:os";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const secretPaths = [
    "/run/secrets",
    "/run/secrets.d",
    `/run/user/${process.getuid?.()}/secrets.d`,
    "/run/user/$UID/secrets.d",
    "/run/user/${UID}/secrets.d",
    `${homedir()}/.config/sops-nix`,
    "$HOME/.config/sops-nix",
    "${HOME}/.config/sops-nix",
    "~/.config/sops-nix",
];

const rules: Array<{ pattern: RegExp; reason: string }> = [
    {
        pattern: /\b(curl|wget)\b[^|]*\|\s*(sudo\s+)?(ba|z|da)?sh\b/,
        reason: "Piping curl/wget into a shell to install software is forbidden on this NixOS system. Use Nix to install software instead.",
    },
    {
        // Bare `/` as a single argument (quoted or not), e.g. `find /`, `du -sh /`.
        pattern: /(?:^|\s)(?:"\/"|'\/'|\/)(?=\s|$)/,
        reason:
            "Passing `/` as a command argument is forbidden on this NixOS system: " +
            "searching from `/` traverses the entire filesystem (extremely slow), and destructive commands like `rm -rf /` are catastrophic. " +
            "Restrict the argument to a specific directory.",
    },
    {
        // `/nix/store` or `/nix/store/` as a single argument (quoted or not).
        pattern:
            /(?:^|\s)(?:"\/nix\/store\/?"|'\/nix\/store\/?'|\/nix\/store\/?)(?=\s|$)/,
        reason:
            "Passing `/nix/store` as a command argument is forbidden on this NixOS system: " +
            "it contains a huge number of files and traversing it is extremely slow, and destructive commands on it are catastrophic. " +
            "Restrict the argument to a specific path inside it, or use `which`, `whereis`, or `nix-locate` to locate system files.",
    },
];

export default function (pi: ExtensionAPI) {
    pi.on("tool_call", async (event, _ctx) => {
        if (event.toolName !== "bash") return undefined;

        const command = event.input.command as string;
        if (secretPaths.some((path) => command.includes(path))) {
            return {
                block: true,
                reason: "Access to secret paths is forbidden.",
            };
        }
        if (command.includes("\n")) return undefined;

        for (const rule of rules) {
            if (rule.pattern.test(command)) {
                return { block: true, reason: rule.reason };
            }
        }
        return undefined;
    });
}
