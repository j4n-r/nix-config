import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { getMarkdownTheme } from "@earendil-works/pi-coding-agent";
import { Key, Markdown, matchesKey, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

type SessionEntry = {
	type?: string;
	message?: {
		role?: string;
		content?: string | Array<{ type?: string; text?: string }>;
	};
};

const commandName = "last";

function textFromAssistant(message: SessionEntry["message"]): string {
	if (!message || message.role !== "assistant") return "";
	if (typeof message.content === "string") return message.content;
	if (!Array.isArray(message.content)) return "";
	return message.content
		.filter((part) => part.type === "text" && typeof part.text === "string")
		.map((part) => part.text)
		.join("\n");
}

export default function (pi: ExtensionAPI): void {
	pi.registerCommand(commandName, {
		description: "Show the last assistant response in a centered Markdown overlay",
		handler: async (_args, ctx) => {
			const branch = ctx.sessionManager.getBranch() as SessionEntry[];
			let markdown = "";

			// getBranch() is ordered from the root to the current leaf.
			for (const entry of branch) {
				const text = entry.type === "message" ? textFromAssistant(entry.message) : "";
				if (text.trim()) markdown = text;
			}

			if (!markdown) {
				ctx.ui.notify("No assistant response to show.", "info");
				return;
			}

			let closeBackdrop: (() => void) | undefined;
			const backdropPromise = ctx.ui.custom<void>(
				(_tui, _theme, _keybindings, done) => {
					closeBackdrop = done;
					return {
						render(width: number): string[] {
							const rows = process.stdout.rows || 40;
							const line = `\u001b[48;2;8;8;12m${" ".repeat(width)}\u001b[0m`;
							return Array.from({ length: rows }, () => line);
						},
						invalidate(): void {},
					};
				},
				{
					overlay: true,
					overlayOptions: {
						anchor: "center",
						width: "100%",
						maxHeight: "100%",
						margin: 0,
						nonCapturing: true,
					},
				},
			);

			try {
				await ctx.ui.custom<void>(
					(tui, theme, _keybindings, done) => {
					const md = new Markdown(markdown, 1, 0, getMarkdownTheme());
					let scroll = 0;
					let contentLength = 0;
					let viewport = 8;

					const component = {
						render(width: number): string[] {
							const innerWidth = Math.max(16, width - 4);
							const content = md.render(innerWidth);
							const terminalHeight = process.stdout.rows || 40;
							// The frame adds four rows: title, divider, help, and bottom border.
							viewport = Math.max(8, Math.floor(terminalHeight * 0.8) - 4);
							contentLength = content.length;
							const maxScroll = Math.max(0, contentLength - viewport);
							scroll = Math.min(scroll, maxScroll);

							const border = (text: string) => theme.fg("borderAccent", text);
							const frame = (line: string) => {
								const clipped = truncateToWidth(line, innerWidth, "");
								const padding = " ".repeat(Math.max(0, innerWidth - visibleWidth(clipped)));
								return `${border("│ ")}${clipped}${padding}${border(" │")}`;
							};
							const label = " last agent response ";
							const titleFill = "─".repeat(Math.max(1, width - label.length - 3));
							const top = `${border("╭─")}${theme.fg("accent", theme.bold(label))}${border(`${titleFill}╮`)}`;
							const divider = border(`├${"─".repeat(Math.max(1, width - 2))}┤`);
							const bottom = border(`╰${"─".repeat(Math.max(1, width - 2))}╯`);
							const shown = content.slice(scroll, scroll + viewport);
							const position = maxScroll > 0 ? ` ${scroll + 1}-${Math.min(scroll + viewport, content.length)}/${content.length}` : "";
							const help = theme.fg("dim", `j/k C-n/C-p · C-d/C-u C-v/M-v · g/G · q${position}`);

							return [top, ...shown.map(frame), divider, frame(help), bottom];
						},
						handleInput(data: string): void {
							const maxScroll = Math.max(0, contentLength - viewport);

							if (matchesKey(data, Key.escape) || data === "q") {
								done();
								return;
							}
							if (matchesKey(data, Key.up) || data === "k" || matchesKey(data, Key.ctrl("p"))) {
								scroll = Math.max(0, scroll - 1);
							} else if (matchesKey(data, Key.down) || data === "j" || matchesKey(data, Key.ctrl("n"))) {
								scroll = Math.min(maxScroll, scroll + 1);
							} else if (matchesKey(data, Key.pageUp) || matchesKey(data, Key.alt("v"))) {
								scroll = Math.max(0, scroll - viewport);
							} else if (matchesKey(data, Key.pageDown) || matchesKey(data, Key.ctrl("v"))) {
								scroll = Math.min(maxScroll, scroll + viewport);
							} else if (matchesKey(data, Key.ctrl("u"))) {
								scroll = Math.max(0, scroll - Math.max(1, Math.floor(viewport / 2)));
							} else if (matchesKey(data, Key.ctrl("d"))) {
								scroll = Math.min(maxScroll, scroll + Math.max(1, Math.floor(viewport / 2)));
							} else if (matchesKey(data, Key.home) || data === "g" || matchesKey(data, Key.alt("<"))) {
								scroll = 0;
							} else if (matchesKey(data, Key.end) || data === "G" || matchesKey(data, Key.alt(">"))) {
								scroll = maxScroll;
							} else return;
							tui.requestRender();
						},
						invalidate(): void {
							md.invalidate();
						},
					};

					return component;
				},
				{
					overlay: true,
					overlayOptions: {
						anchor: "center",
						width: "28%",
						minWidth: 44,
						maxHeight: "80%",
						offsetX: process.env.HERDR_ENV ? -10 : 0,
						margin: 1,
					},
					},
				);
			} finally {
				closeBackdrop?.();
				await backdropPromise;
			}
		},
	});
}
