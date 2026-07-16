import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

type PaneManager = {
  executable: string;
  label: string;
  paneArguments: (cwd: string, sessionFile: string) => string[];
};

function shellQuote(value: string): string {
  return `'${value.replaceAll("'", `'\\''`)}'`;
}

const tmux: PaneManager = {
  executable: "tmux",
  label: "tmux",
  paneArguments: (cwd, sessionFile) => [
    "split-window",
    "-v",
    "-c",
    cwd,
    `pi --fork ${shellQuote(sessionFile)}`,
  ],
};

const zellij: PaneManager = {
  executable: "zellij",
  label: "Zellij",
  paneArguments: (cwd, sessionFile) => [
    "action",
    "new-pane",
    "--direction",
    "down",
    "--cwd",
    cwd,
    "--",
    "pi",
    "--fork",
    sessionFile,
  ],
};

function detectPaneManager(): PaneManager | undefined {
  if (process.env.ZELLIJ) return zellij;
  if (process.env.TMUX) return tmux;
  return undefined;
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("fork-pane", {
    description: "Fork the current Pi session into a new pane below",
    handler: async (_args, ctx) => {
      const paneManager = detectPaneManager();
      if (!paneManager) {
        ctx.ui.notify("/fork-pane requires tmux or Zellij", "error");
        return;
      }

      await ctx.waitForIdle();

      const sessionFile = ctx.sessionManager.getSessionFile();
      if (!sessionFile) {
        ctx.ui.notify("Cannot fork an ephemeral session", "error");
        return;
      }

      try {
        const result = await pi.exec(
          paneManager.executable,
          paneManager.paneArguments(ctx.cwd, sessionFile),
          { timeout: 5_000 },
        );

        if (result.code !== 0) {
          const message =
            result.stderr.trim() || `${paneManager.label} could not create the pane`;
          ctx.ui.notify(`${paneManager.label} failed to fork the session: ${message}`, "error");
        }
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        ctx.ui.notify(`${paneManager.label} failed to fork the session: ${message}`, "error");
      }
    },
  });
}
