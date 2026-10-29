# statechart — Changelog

## v1.0.0 — 2026-10-28

Vendored from cursor/plugins pstack @ c742dd6.

- Dropped `scripts/test/` (TLA+ test corpus, ~380 files / 2.7 MB). The runtime scripts are unchanged; run upstream's tests from the pstack repo if you change the scripts.

- Not runnable on native Windows: the Node driver spawns `/bin/sh` and uses `kill -- -<pgid>` for cleanup. Verified 2026-10-29 with Node 22.23.4 and mise 2026.10.12 (spawn /bin/sh ENOENT). Use Linux, macOS, or WSL.
