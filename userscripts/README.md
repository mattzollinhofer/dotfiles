## userscripts

Userscripts loaded into Tampermonkey (or any compatible manager — Violentmonkey, Greasemonkey).

These are *source* — Tampermonkey stores its installed scripts in browser-local storage, not on disk. To use one of these:

- **One-off:** open the file, copy contents, paste into a new Tampermonkey script.
- **Synced (preferred):** in Tampermonkey, "Utilities → Import from URL" pointing at a `file://` or remote URL. Or commit these to a public gist and use Tampermonkey's "@updateURL" to auto-pull.

One file per script. Keep the `==UserScript==` header self-contained so the file is independently installable.
