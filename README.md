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
| `cmux-organize [ws]` | Auto-classify surfaces into themed panes | `/cmux-kit:organize` |
| `cmux-snapshot [name]` | Save current layout + Claude session snapshot | `/cmux-kit:snapshot` |
| `cmux-restore [name]` | Restore layout + Claude sessions from snapshot | `/cmux-kit:restore` |
| `cmux-preview <file.md>` | Live Markdown side-panel preview | `/cmux-kit:preview` |
| `cmux-day-start` | Create all workspaces at day start | `/cmux-kit:day-start` |
| `cmux-skills [dir]` | Claude skill dev + file nav layout | `/cmux-kit:layout-skills` |
| `cmux-web [dir] [cmd]` | Claude + dev server layout | `/cmux-kit:layout-web` |

---

## cmux-organize: Classification Rules

| Group | Keyword Patterns |
|-------|-----------------|
| **research** | research, deep.dive, survey, 리서치, 조사 |
| **tools** | skill, plugin, hook, claude, n8n, obsidian, kaizen |
| **work** | everything else (stays in main pane) |

```
Before                  After
┌────────────────┐      ┌──────────┬──────────┐
│ work-1         │      │ work-1   │research-1│
│ work-2         │  →   │ work-2   ├──────────┤
│ research-1     │      │          │ tools-1  │
│ tools-1        │      │          │          │
└────────────────┘      └──────────┴──────────┘
```

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

## Uninstall

```bash
./uninstall.sh
```

---

## License

MIT © [sanghun0724](https://github.com/sanghun0724)
