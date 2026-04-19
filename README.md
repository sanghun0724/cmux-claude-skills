# cmux-claude-skills

> **macOS only** · Requires [cmux.app](https://cmux.app) + [Claude Code](https://claude.ai/code)

Automation scripts that connect [cmux](https://cmux.app) terminal with Claude Code.  
Provides workspace layout setup, surface auto-classification, Claude session snapshot/restore, and Markdown live preview.

[한국어 README →](README.ko.md)

---

## Requirements

- macOS 12+
- [cmux.app](https://cmux.app) installed with `cmux` CLI in your PATH
- [Claude Code](https://claude.ai/code) CLI (`claude`)
- Python 3.9+ (for `cmux-snapshot` and `cmux-restore`)

---

## Install

### 1. Install executables

```bash
git clone https://github.com/sanghun0724/cmux-claude-skills.git
cd cmux-claude-skills
./install.sh
```

If `~/.local/bin` is not in your PATH, add it to your shell config:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 2. Install as Claude Code plugin (optional)

To use slash commands (`/cmux-kit:organize` etc.) inside Claude Code:

```
/plugin marketplace add sanghun0724/cmux-claude-skills
/plugin install cmux-kit
```

> **Note:** Plugin install alone does **not** install the CLI tools. You must also run `./install.sh` (step 1).

### 3. Customize day-start

`cmux-day-start` requires customization for your own project paths:

```bash
cp bin/cmux-day-start.example ~/.local/bin/cmux-day-start
chmod +x ~/.local/bin/cmux-day-start
$EDITOR ~/.local/bin/cmux-day-start  # edit PROJECTS_ROOT and workspace list
```

---

## Commands

| Command | Description | Slash Command |
|---------|-------------|---------------|
| `cmux-organize [ws]` | Keyword-based surface classifier (standalone) | — |
| `/cmux-kit:organize` | **AI-powered** classifier — Claude reads surfaces and classifies by context | `/cmux-kit:organize` |
| `cmux-snapshot [name]` | Save current layout + Claude session snapshot | `/cmux-kit:snapshot` |
| `cmux-restore [name]` | Restore layout + Claude sessions from snapshot | `/cmux-kit:restore` |
| `cmux-preview <file.md>` | Live Markdown side-panel preview | `/cmux-kit:preview` |
| `cmux-day-start` | Create all workspaces at day start | `/cmux-kit:day-start` |
| `cmux-skills [dir]` | Claude skill dev + file nav layout | `/cmux-kit:layout-skills` |
| `cmux-web [dir] [cmd]` | Claude + dev server layout | `/cmux-kit:layout-web` |

---

## cmux-organize: How it works

The skill uses a **two-stage pipeline**:

**Stage 1 — Explore**: Claude reads all surface titles in the workspace via `cmux list-pane-surfaces`.

**Stage 2 — Classify**: Claude reasons about each surface title by context (not keywords) and proposes a grouping:

| Group | Judgment Criteria |
|-------|------------------|
| **research** | Info gathering, docs, references, learning |
| **tools** | Dev tools, plugins, settings, skill development |
| **work** | Active coding, tasks, PRs (stays in main pane) |

Claude shows the classification plan for confirmation before executing. You can correct any misclassified surfaces before changes are applied.

**Stage 3 — Reorganize**: `cmux-reorganize` moves surfaces into new panes based on the confirmed plan.

```
Before                  After
┌────────────────┐      ┌──────────┬──────────┐
│ work-1         │      │ work-1   │research-1│
│ work-2         │  →   │ work-2   ├──────────┤
│ research-1     │      │          │ tools-1  │
│ tools-1        │      │          │          │
└────────────────┘      └──────────┴──────────┘
```

> `cmux-organize` (CLI) still works standalone with keyword-based matching as a fallback.

---

## cmux-snapshot / cmux-restore: Session Recovery

Recover your Claude sessions even after cmux crashes.

**Auto-snapshot on session end** (`~/.claude/settings.json`):

```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "cmux-snapshot latest 2>/dev/null || true"
      }]
    }]
  }
}
```

**Restore:**

```bash
cmux-restore          # use latest snapshot
cmux-restore mywork   # use ~/.cmux-snapshots/mywork.json
```

**Slow machine?** Increase the delay between cmux commands:

```bash
CMUX_RESTORE_DELAY=1.0 cmux-restore
```

> **Limitations:** Session ID matching is fuzzy (surface title vs `~/.claude/projects/` index).  
> Snapshot reads cmux's internal session JSON — may break on cmux updates.

---

## Environment Variables

All scripts support environment variables so you can adapt them to your setup without modifying the files.

| Variable | Default | Used by |
|----------|---------|---------|
| `CMUX_SNAPSHOT_DIR` | `~/.cmux-snapshots` | `cmux-snapshot`, `cmux-restore` |
| `CMUX_SESSION_FILE` | `~/Library/Application Support/cmux/session-com.cmuxterm.app.json` | `cmux-snapshot` |
| `CMUX_CLAUDE_PROJECTS` | `~/.claude/projects` | `cmux-snapshot` |
| `CMUX_RESTORE_DELAY` | `0.3` | `cmux-restore` (seconds between cmux calls) |
| `CMUX_RESEARCH_KEYWORDS` | built-in list | `cmux-organize` (pipe-separated regex alternation) |
| `CMUX_TOOLS_KEYWORDS` | built-in list | `cmux-organize` (pipe-separated regex alternation) |
| `CMUX_WEB_DEV_CMD` | `npm run dev` | `cmux-web` |
| `CMUX_INIT_DELAY` | `0.4` | `cmux-day-start` (seconds after workspace creation) |
| `CMUX_BIN_DIR` | `~/.local/bin` | `install.sh`, `uninstall.sh` |

**Example — custom keyword classification:**

```bash
export CMUX_RESEARCH_KEYWORDS="research|deep.dive|survey|docs"
export CMUX_TOOLS_KEYWORDS="plugin|hook|claude|obsidian|n8n"
cmux-organize workspace:1
```

**Example — non-standard cmux session path:**

```bash
CMUX_SESSION_FILE="/path/to/custom-session.json" cmux-snapshot
```

---

## Uninstall

```bash
./uninstall.sh
```

---

## License

MIT © [sanghun0724](https://github.com/sanghun0724)
