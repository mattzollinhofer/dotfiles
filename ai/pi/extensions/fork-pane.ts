import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function shellQuote(value: string): string {
  return `'${value.replaceAll("'", `'\\''`)}'`;
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("fork-pane", {
    description: "Fork the current Pi session into a new tmux pane below",
    handler: async (_args, ctx) => {
      if (!process.env.TMUX) {
        ctx.ui.notify("/fork-pane requires tmux", "error");
        return;
      }

      await ctx.waitForIdle();

      const sessionFile = ctx.sessionManager.getSessionFile();
      if (!sessionFile) {
        ctx.ui.notify("Cannot fork an ephemeral session", "error");
        return;
      }

      const command = `pi --fork ${shellQuote(sessionFile)}`;
      const result = await pi.exec(
        "tmux",
        ["split-window", "-v", "-c", ctx.cwd, command],
        { timeout: 5_000 },
      );

      if (result.code !== 0) {
        const message = result.stderr.trim() || "tmux could not create the pane";
        ctx.ui.notify(`Failed to fork session: ${message}`, "error");
      }
    },
  });
}
