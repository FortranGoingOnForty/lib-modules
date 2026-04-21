# Reference Libraries

This repo keeps tracked package code out of the umbrella tree, but it is still
useful to study existing libraries before we start a new module.

Local comparison checkouts live under `.refs/` and stay untracked. The tracked
part of the workflow is:

- this manifest
- `scripts/sync-refs.sh`

Run the sync script from the umbrella root:

```bash
./scripts/sync-refs.sh
```

## Current Read

The best next flagship still looks like `fgof-keys`.

Why:

- it builds directly on `fgof-termios`, `fgof-pty`, and `fgof-lineedit`
- terminal key handling is still undersupplied compared with process, fs, PTY,
  and raw terminal mode helpers
- it creates a cleaner foundation for future `fgof-screen` and richer CLI or
  TUI work

The most interesting "crowded area we might still beat" is not another raw
ncurses binding. It is a higher-level screen or rendering library such as a
future `fgof-screen`.

## Seed Reference Set

The first seed is intentionally small and focused. It is meant to support the
next few likely package decisions without turning `.refs/` into a dumping
ground.

| Group | Repo | Why it matters |
| --- | --- | --- |
| `stdlib` | `fortran-lang/stdlib` | Standard-library baseline and overlap check |
| `terminal-ui` | `interkosmos/fortran-ncurses` | Modern thin ncurses binding baseline |
| `terminal-ui` | `urbanjost/M_ncurses` | Mature ncurses binding baseline |
| `system` | `urbanjost/M_process` | Existing process wrapper comparison |
| `system` | `urbanjost/M_system` | Existing POSIX and OS wrapper comparison |
| `system` | `interkosmos/fortran-unix` | Thin POSIX binding comparison |
| `testing` | `fortran-lang/test-drive` | Test utility baseline for `fgof-proc-test` |
| `testing` | `everythingfunctional/vegetables` | Alternate test utility baseline |

## What To Look For

When we compare against a deferred or already-served area, we should be asking:

- Is the existing package a thin binding or a genuinely ergonomic library?
- Does it have strong `fpm` support and examples?
- Does it expose low-level C semantics directly to users?
- Does it preserve literal strings and path data cleanly?
- Does it provide a stable, app-author-friendly API or mainly raw wrappers?
- Does it cover current compiler and CI expectations on macOS and Linux?

If the answer is "mostly thin wrappers," there is still room for an `fgof-*`
package that offers a better developer surface.

## Shortlist After The First Wave

- `fgof-keys`
- `fgof-expect`
- `fgof-proc-test`
- `fgof-temp`
- `fgof-clipboard`
- `fgof-screen`

## Notes

- `.refs/` is intentionally untracked.
- Add new comparison targets to the sync script and this manifest together.
- If we decide to study a crowded area in depth, create a short audit note in
  this `docs/` directory instead of committing cloned source.
