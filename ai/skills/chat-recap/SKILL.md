---
name: chat-recap
description: Summarize a live chat, call, or meeting into a short, casual, copy-pasteable recap for teammates who didn't attend. Use whenever the user wants to share what was discussed with people who weren't there — phrases like "summarize this chat for the team", "write something for Slack about the call", "recap for folks who missed it", "quick summary of the chat", "TL;DR of the meeting", "what should I tell everyone who wasn't on the call". Also use right after summarizing a transcript when the user wants a shareable blurb out of it.
---

# Chat Recap

Turn a live chat, call, or meeting into a short recap the user can paste into Slack for people who weren't there. The reader gets the point in a few seconds without watching a recording or reading a transcript.

The deliverable is a casual blurb that sounds like the user wrote it, not a formal minutes document. Think "message to a coworker," not "report."

## Where the chat comes from

The source is usually a transcript under `~/transcriptions`. Resolve it in this order, and don't over-ask:

1. If the user pointed at a specific file or pasted the text, use that.
2. If the conversation already mentioned or summarized a specific chat, use that one — don't make them repeat themselves.
3. If it's obvious (e.g. one clearly-recent transcript in today's folder), grab it and name which one you grabbed as you go.
4. Otherwise ask which chat they mean.

For the mechanics of locating and reading transcripts (privacy gate, `find`/`rg` patterns, reading automated transcripts critically), follow the `transcript-research` skill. Automated transcripts have duplicated speakers, homophone errors, and overlapping dialogue — reconcile them, don't quote them verbatim.

## Output contract

Two parts, in this order:

1. **Supporting detail first** (when the chat warrants it) — a few tight bullets covering the threads worth capturing: what was decided, what setup/context matters, any loose ends.
2. **The blurb last** — the copy-pasteable recap. It always comes last so the thing the user copies sits at the bottom of your message, easy to grab.

The blurb is the actual deliverable. The detail above it is scaffolding the user can glance at or ignore. Keep the detail short; skip it entirely when the blurb already says everything. Never bury the blurb in the middle.

## Writing the blurb

The blurb reads like the user dashed off a Slack message. Concretely:

- **One short paragraph.** No bullets inside the blurb, no headers. A few sentences.
- **Lead with the point** — the decision or the takeaway, not the backstory. The reader who skipped the call wants to know the outcome first.
- **Drop the chatter.** Cut pure social banter and tangents — tooling opinions, industry gossip, off-topic riffs — unless they produced an actual decision. The recap is for what the reader needs to know, not a play-by-play. A wide-ranging call with no single point gets a blurb of the 2-4 headline outcomes rather than one forced takeaway.
- **Varied casual opener.** Open with a short lead-in, but vary the wording every time — never reuse one fixed phrase. Rotate through things like: `quick summary of chat:`, `chat summary:`, `summary:`, `if you weren't here:`, `anyone following along:`, `tl;dr of the call:`, `for anyone who missed it:`. Match the user's voice; lowercase and loose is fine.
- **Name people by first name.** This is an internal share among teammates who know each other, so "Casey and Shannon expected it to work" is right — more useful than "two participants." This intentionally overrides the roles-not-names default in `transcript-research`, which exists for privacy in analysis; here the audience already knows everyone. (If the chat clearly involves customers, candidates, or anything sensitive, fall back to roles.)
- **Names are the risky part.** Automated transcripts routinely misattribute who said what, and in a shareable post a wrong name misassigns work publicly — worse than saying nothing. So only attach a name to an action when the transcript makes the owner unambiguous. When attribution is fuzzy, phrase around it ("someone's picking that up", "the Sunrise dig") instead of guessing. Better to drop a name than pin work on the wrong person. Before naming anyone, check `references/team.md` — it disambiguates people who collide or get mislabeled (there are two Ryans; the `Me` speaker is Z, the person the recap is from) and maps first-person lines to the right owner.
- **Note the loose ends.** If something came up but wasn't resolved, say so plainly and briefly: "there was a bit of chat about X, but didn't dig into it ... might look at it later." This tells the reader what's still open without pretending it was settled.
- **Sound like a person, not a summary bot.** Slightly loose grammar and a trailing `...` for an unfinished thought are fine and good — they're what make it read as human.

### No AI writing

The blurb must not read as machine-generated. After drafting, run it through the `avoid-ai-writing` skill at the `casual` profile (Slack message). The two things that matter most here:

- **No em dashes or `--`.** Use commas, periods, or a trailing `...`. This is a hard rule for the blurb — the user asks for it explicitly.
- **No AI-isms** — no "leverage", "robust", "seamless", "it's worth noting", "delve", inflated significance, or copula-avoiding verbs like "serves as". Just say what happened.

## Gold-standard example

This is the target voice and shape. The chat: a call working out whether an "automation not firing" report was a real bug.

**Detail (above the blurb):**
- Automation setup: filter `score = warm/hot`, trigger = complete any activity. Test prospect was `cold`, outside the filter.
- Completing an activity that moved the prospect into the filter did not fire the automation. Casey expected that.
- Group agreed this is expected behavior, so the bug gets closed.
- Stage-advance trigger backfills the filter to the destination stage and behaves differently — raised but not explored.

**Blurb (last, copy-pasteable):**

> quick summary of chat: the current behavior is correct: the automation doesn't fire when completing an activity moves someone into the filter. it only fires if they're already in the filter when the trigger runs. that matches how Casey and Shannon expected it to work, so the bug will get closed. there was a bit of chat about the stage-advance trigger behaving differently, but didn't dig into it ... might consider it more later.

Notice: leads with the outcome, names names, one paragraph, flags the loose end without resolving it, no em dashes, sounds like a person.

## When the user asks for just the blurb

If they say "just the blurb" or "one line I can paste," skip the detail and return only the blurb. Default to including the detail above it, since it's cheap for them to ignore and useful when they want to double-check before sharing.
