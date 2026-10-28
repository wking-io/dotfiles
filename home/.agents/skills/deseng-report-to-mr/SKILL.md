---
name: deseng-report-to-mr
description: Turn a Dash UI bug report (Google Chat thread, linked post, or screenshot) into a diagnosis, a DESENG ticket, a pushed branch, and a merge request with before/after screenshots.
argument-hint: "Chat thread URL or report description"
disable-model-invocation: true
---

# DESENG report → MR

Run in the Stratus repo. Each phase ends on a checkable criterion; finish it before starting the next. Stratus repo skills own the generic mechanics: load `jira`, `commit`, `pr`, and `repo-validation` from `.opencode/skills/` when their phase starts, and follow them unless this file overrides them.

Use **synthetic data** in all artifacts (ticket, commit, screenshots, MR). External reports often show real emails, account names, and hostnames: describe them, never attach them.

## 1. Read the report

- Google Chat: call `google_workspace_mcp_chat_get_thread({ threadUrl })` through `mcp__cf_portal__portal_codemode_execute`. Pass the full `chat.google.com/room/...` URL as `threadUrl`.
- X/Twitter links: `curl -s https://api.fxtwitter.com/<user>/status/<id>` returns text and media URLs. Download each image and view it with `read`.

Done when you can list every distinct symptom in the report, each tied to a page and component.

## 2. Diagnose

For each symptom, find the rendering component (`rg` the visible copy), then `git log` it and the shared style entry points:

- `src/apps/dash/react/common/styles/styles.css`: Dash **omits Tailwind preflight**. Bare native elements (`button`, `input`, `fieldset`) keep browser defaults unless something resets them.
- `src/apps/dash/startup/initStyles.ts`: legacy `@layer cf` base rules, for example `button { border: none }` only.
- Kumo version bumps: diff the published tarballs (`npm pack @cloudflare/kumo@X`) and read `CHANGELOG.md`.

Reproduce rather than guess. The fastest check is to render the component's real markup against the live production stylesheet with [`scripts/render-with-prod-css.sh`](scripts/render-with-prod-css.sh), in `dark` and `light`. Its output is a **simulated render**: use it for diagnosis only, never as MR screenshots. Find the introducing commit with `git log -L '/function Name/,/^}/:<file>'`.

Done when each symptom is **reproduced** (with the cause and the introducing commit) or **unreproduced** (with what was ruled out and what info is needed, such as browser and extensions). Present this to the user and agree on the fix approach before editing. Prefer a supported Kumo path; when the call site needs something Kumo cannot express, match the nearest sibling component's pattern and note the Kumo gap.

## 3. Fix and validate

Make the smallest change. Run the owning test runner plus `oxfmt --check` and `pnpm lint:oxlint` on the touched files, per `repo-validation`.

Done when the related tests pass and the format and lint checks are clean.

## 4. Ticket

Follow the `jira` skill with these DESENG defaults, which match recent team tickets:

- Project `DESENG`, type `Task`, priority `P4 Normal`, assignee = current user, no epic, no sprint.
- Summary: imperative and user-visible ("Remove gray background from Worker variable names").
- Description in Jira wiki markup: `h2. Context` (symptom plus the Chat `[Thread|url]` link), `h2. Cause`, `h2. Scope`, `h2. Out of scope` (unreproduced symptoms, follow-up proposals).

Done when the API returns a `DESENG-####` key.

## 5. Branch and commit

- Branch `<git-email-user>/DESENG-####` from `origin/staging`. Carry the fix over with `git checkout -b <branch> origin/staging`.
- Stage **only the files you changed**. The worktree often has unrelated edits; leave them unstaged.
- Commit per the `commit` skill: `fix(DESENG-####): <imperative summary>`, a short body with the cause, then the `get-co-authors` trailers.
- `git push -u origin <branch>`. pnpm `401`/`ERR_PNPM_META_FETCH_FAIL` noise from the hook's auto-install is unrelated; the push is fine when git prints `[new branch]`.

Done when the branch exists on `origin` with exactly the fix commit.

## 6. Before/after screenshots

Capture MR screenshots **only from the running local Dash server in the Rex tab labelled `prod`** (`pnpm prod` → `https://localhost:7445`, local build proxied to production data). Simulated renders, preview environments, and production itself are out of bounds for MR screenshots.

1. **Find the server.** `rex window ls -s "$REX_SESSION" --json`, take the window labelled `prod`, and `rex capture -b <block> --trim`. It must show `Local: https://localhost:7445/` with no `Build error` after it.
   - A `Build error` / `UNLOADABLE_DEPENDENCY` after a branch switch means a stale module graph. Restart it in the same tab. If the pane runs `pnpm prod` directly (no shell underneath), Ctrl-C closes the pane. Run `rex split -b <block> --split=below -c <repo> --label prod --keep-open --focus=false -- pnpm prod`, then `rex block close <old-block>`. Wait for `Local:`.
   - If no `prod` tab exists, stop and ask the user. Do not start a server elsewhere.
2. **Attach the browser.** Use the repo's `dash-browser-verify` skill with `SEED_ORIGIN=https://dash.cloudflare.com` and `DASH_BASE=https://localhost:7445`. It needs the debug Chrome on port 9222 (`.opencode/skills/dash-browser-verify/scripts/launch-chrome.sh https://dash.cloudflare.com`). The user logs in by SSO once in that window. Ask them to, then confirm with `curl -s http://127.0.0.1:9222/json/version`.
3. **Pick test data in Burrito Bot.** Do all testing in the **Burrito Bot** account. The login is `Administrator Read Only` there, so creating resources fails with `403`: choose an existing resource whose visible values are clearly test data (for example, Worker `test-metrics-export-140826-worker-a` with `E2E_VERSION = v1`). Inspect values through the API before choosing, and crop to the changed region so unrelated names stay out of frame. Never capture account IDs, customer data, or real emails. If no suitable resource exists, add in-app MSW handlers (dash-browser-verify Tier 2) and keep them out of the commit.
4. **Capture after, then before** with [`scripts/capture-local.cjs`](scripts/capture-local.cjs) (usage is in its header comment). It seeds the session onto localhost, resolves Burrito Bot by name, crops to the target region, and toggles dark mode client-side so the user's saved Appearance preference never changes. It prints the target's `class` for each capture: check it to confirm which code rendered.
   - **After**: run with the branch as committed.
   - **Before**: the fix is already committed by now, so `git stash` does nothing. Write the base version over the file with `git show origin/staging:<fix-file> > <fix-file>`, wait about 10 s for Vite to rebuild, capture, then `git checkout -- <fix-file>`. Confirm `git status` is clean for that file.
5. **Check.** View every PNG with `read`. Before must show the bug, after must not, and no frame may show a login page, spinner, or real data.
6. **Upload** each PNG with [`scripts/upload-to-gitlab.sh`](scripts/upload-to-gitlab.sh). It prints the markdown link.

Done when four uploaded links exist (before/after × dark/light), each captured from `https://localhost:7445` and visually checked.

## 7. Merge request

Follow the `pr` skill's template, with these DESENG conventions from recent merged MRs:

- Title `DESENG-#### | <imperative summary>`. Use `--remove-source-branch --squash-before-merge --yes`, and add the `/label ~made-with-ai` line.
- **Description**: what changed and why, then a Before/After table:

  ```markdown
  | | Before | After |
  | --- | --- | --- |
  | Dark | ![..](/uploads/..) | ![..](/uploads/..) |
  | Light | ![..](/uploads/..) | ![..](/uploads/..) |
  ```

- **Context**: Jira link, the introducing commit and MR, the Kumo gap if any, and what is out of scope.
- **How to test**: numbered UI steps plus the automated test that covers it.
- **Screenshots & Videos**: state that the screenshots come from the local `pnpm prod` build at `localhost:7445` (before = `staging` code, after = this branch), using synthetic data.
- Reviewers: suggest `mrothenberg` (reviewer on most DESENG MRs) and ask before adding.

Then add the MR URL as a comment on the Jira ticket.

Done when the MR URL is returned, its title, labels, and squash settings are verified with `glab api projects/5762/merge_requests/<iid>`, and the Jira comment exists. Report the ticket, branch, commit, MR, and any unreproduced symptoms with their next step.
