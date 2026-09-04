/**
 * Pi Agent Notifier
 *
 * Equivalent of the Claude Code on-notification.sh hook, but for Pi.
 *
 * When Pi finishes a run and is idle (i.e. it is now the user's turn — the
 * "awaiting input" / "done" moment), it locates its own Hyprland window (by
 * the unique `Pi-$PI_INSTANCE_ID` title that the zsh `pi()` launcher sets)
 * and, if that window is not focused:
 *   - tags it `urgent*` so the Quickshell AgentWidget lights up,
 *   - fires a custom `pi-urgent` event so the widget refreshes immediately,
 *   - sends a desktop notification.
 *
 * The hyprland `clear urgent` window rule removes the tag again on focus,
 * and the `agents` window rule (class = "agent") is what places Pi on the
 * `special:agents` workspace in the first place.
 *
 * Skips silently when Hyprland/notify-send aren't present or when launched
 * directly (no PI_INSTANCE_ID), e.g. running `pi` without the launcher.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFileSync } from "node:child_process";

export default function (pi: ExtensionAPI) {
	pi.on("agent_settled", async (_event, ctx) => {
		// agent_settled fires after a run ends, possibly followed by retries /
		// auto-compaction or queued follow-ups. Only notify once Pi is truly
		// idle and waiting for the user (the "needs input" moment).
		if (!ctx.isIdle()) return;

		const instanceId = process.env.PI_INSTANCE_ID;
		if (!instanceId) return;

		const title = `Pi-${instanceId}`;
		let selfAddress: string | undefined;

		try {
			const clients = JSON.parse(
				execFileSync("hyprctl", ["clients", "-j"], { encoding: "utf8" }),
			);
			const win = (clients as any[]).find((c) => c.title === title);
			if (!win) return;

			const focused = JSON.parse(
				execFileSync("hyprctl", ["activewindow", "-j"], { encoding: "utf8" }),
			);

			// If the user is already looking at this Pi window, no need to nag.
			if (focused.address === win.address) return;

			selfAddress = win.address;
		} catch {
			// Hyprland not running or title not found yet — nothing to notify.
			return;
		}

		if (selfAddress) {
			try {
				execFileSync("hyprctl", [
					"dispatch",
					`hl.dsp.window.tag({window = 'address:${selfAddress}', tag = '+urgent*'})`,
				]);
				execFileSync("hyprctl", [
					"dispatch",
					"hl.dsp.event('pi-urgent')",
				]);
			} catch {
				// Tagging failed; fall through so notify-send still fires.
			}
		}

		try {
			execFileSync("notify-send", [
				"Pi",
				"Awaiting input",
				"--app-name=Pi",
			]);
		} catch {
			// notify-send unavailable — the urgent tag is the primary signal.
		}
	});
}
