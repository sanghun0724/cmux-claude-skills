# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-04-19

### Added

- `cmux-organize`: Keyword-based surface classifier (standalone fallback)
- `cmux-reorganize`: Mechanical pane reorganizer — accepts explicit surface group assignments
- `/cmux-kit:organize` skill: AI-powered two-stage pipeline (explore → Claude classifies → reorganize)
- `cmux-snapshot`: Save cmux layout + Claude session IDs as JSON snapshot
- `cmux-restore`: Restore layout + Claude sessions from snapshot (`CMUX_RESTORE_DELAY` env var)
- `cmux-preview`: Live Markdown side-panel preview
- `cmux-skills`: Claude skill dev + file navigation layout
- `cmux-web`: Claude + dev server layout
- `cmux-day-start.example`: Day-start workspace template
- Claude Code plugin manifest (`cmux-kit`)
- `install.sh` / `uninstall.sh`
- `README.md` (English) + `README.ko.md` (한국어)
