const aliases: Record<string, glide.ExcmdString> = {
    bd: "tab_close",
    buffer_delete: "tab_close",
    bp: "tab_prev",
    buffer_previous: "tab_prev",
    bn: "tab_next",
    buffer_next: "tab_next",
};

for (const [name, command] of Object.entries(aliases)) {
    glide.excmds.create({ name, description: `alias to ${command}` }, () =>
        glide.excmds.execute(command),
    );
}
