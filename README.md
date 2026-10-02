# Rofy CLI

Make images and videos with Rofy from your terminal, or let an AI assistant
such as Claude Code, Cursor or Codex do it for you.

> **Preview.** Versions 0.0.x are for Rofy's own testing and do not reach the
> live service yet.

## Install

```bash
npm i -g @rofy/cli
```

Without Node, on macOS or Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/rofy-ai/rofy-cli/main/install.sh | sh
```

Or download the file for your system from
[Releases](https://github.com/rofy-ai/rofy-cli/releases), unpack it, and put it
on your `PATH`. Works on macOS, Linux and Windows, on x64 and arm64.

## Set up for an AI assistant

Paste this to your assistant:

```
Set up Rofy for me so I can generate images and videos from here.

1. Install the CLI: run `npm i -g @rofy/cli`.
2. Authenticate: run `rofy auth login` and complete the sign-in in the browser it opens.
3. Install the companion skills: run `npx skills add rofy-ai/skills`.

Once that's done, let me know when it's ready.
```

The skills are in [rofy-ai/skills](https://github.com/rofy-ai/skills).

## Sign in and choose a workspace

```bash
rofy auth login      # opens your browser
rofy workspace       # choose where to work: arrow keys, then Enter
rofy account         # who is signed in, the workspace, its credits
```

Your personal workspace and each team have their own credits. Rofy never
assumes one: until you choose, nothing that reads or spends credits runs.

## Generate

```bash
rofy model list --type video
rofy model get seedance_1_5_pro

rofy generate create flux_2 --prompt "a red fox in the snow" --num_images 1 --wait
rofy generate create seedance_1_5_pro --prompt "the fox walks toward the camera" \
  --image_url ./fox.png --duration 5 --resolution 720p --wait
```

- `rofy model get <model>` lists the model's settings, media inputs and prices.
  Each setting is a flag.
- A media flag takes a file on your computer, which is uploaded for you, or a link.
- A wrong flag or value is refused before anything is uploaded or charged.
- `--wait` waits for the result and prints its link. Without it, the job's
  number is printed, and `rofy generate wait <job>` picks it up later.
- A failed job is refunded.

## Commands

| Command | What it does |
|---|---|
| `rofy auth login`, `rofy auth logout` | Sign in through the browser. Sign out and cancel the session |
| `rofy account` | The signed-in account, the workspace, its credits |
| `rofy workspace`, `rofy workspace use "<name>"`, `rofy workspace list` | Choose or show the workspace |
| `rofy model list [--type image\|video]`, `rofy model get <model>` | The models and what each accepts |
| `rofy generate create <model> ...` | Start an image or a video |
| `rofy generate wait <job>`, `rofy generate get <job>` | Wait for a job, or check it once |
| `rofy generate list [--type image\|video] [--limit 10]` | Recent results |
| `rofy upload <file>...` | Upload files and print their links |
| `rofy version` | The version, commit and build date |

Add `--json` to any command for output a program can read.

## Exit codes

| Code | Meaning |
|---|---|
| 0 | Done |
| 1 | The service or the job failed |
| 2 | Wrong command, flag or value. Nothing was charged |
| 3 | Not signed in |
| 4 | No workspace chosen, or the chosen team is no longer available |

## Your data

- **Your session** is kept in `~/.rofy/credentials.json`, readable only by
  you. `rofy auth logout` cancels it. Set `ROFY_CONFIG_DIR` to keep it elsewhere.
- **Error reports.** If the program crashes or the service fails, a report is
  sent so it can be fixed: the command's name, the version, your system, and
  the request that failed. Never your prompts, files, tokens, name or email.
  Turn it off with `DO_NOT_TRACK=1` or `ROFY_DISABLE_TELEMETRY=1`.
- **Update check.** Once a day, at a terminal, the program asks this
  repository for the latest version. Turn it off with `ROFY_NO_UPDATE_CHECK=1`.

## Update and remove

```bash
npm i -g @rofy/cli@latest     # update
npm rm -g @rofy/cli           # remove
```

Installed with the script: run it again to update, and delete
`/usr/local/bin/rofy` to remove.

## Checking a download

Every release lists the SHA-256 of each file in `checksums.json`. The npm
package and the install script both refuse a file whose fingerprint differs.

## Third-party software

See [THIRD-PARTY-NOTICES.txt](THIRD-PARTY-NOTICES.txt).
