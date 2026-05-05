# lib-modules

This repository is the umbrella catalog for reusable Fortran packages developed under the `FortranGoingOnForty` umbrella.

It is intentionally not a traditional code monorepo.

The goal is:

- keep shared docs, roadmap, and package discovery in one place
- keep each package in its own repository with its own history, releases, issues, and CI
- collect those package repos here as Git submodules under `packages/`

That gives us the discoverability and organization benefits of one home page without burying every package inside a giant top-level repo.

Start here if you want the big-picture package map:

- [LANDSCAPE.md](LANDSCAPE.md)

Go straight to the first standalone package if you already know what you want:

- [fgof-process](https://github.com/FortranGoingOnForty/fgof-process)
- [fgof-fs](https://github.com/FortranGoingOnForty/fgof-fs)
- [fgof-pty](https://github.com/FortranGoingOnForty/fgof-pty)
- [fgof-lineedit](https://github.com/FortranGoingOnForty/fgof-lineedit)
- [fgof-watch](https://github.com/FortranGoingOnForty/fgof-watch)
- [fgof-termios](https://github.com/FortranGoingOnForty/fgof-termios)
- [fgof-keys](https://github.com/FortranGoingOnForty/fgof-keys)
- [fgof-expect](https://github.com/FortranGoingOnForty/fgof-expect)
- [fgof-proc-test](https://github.com/FortranGoingOnForty/fgof-proc-test)
- [fgof-temp](https://github.com/FortranGoingOnForty/fgof-temp)
- [fgof-cache](https://github.com/FortranGoingOnForty/fgof-cache)
- [fgof-state](https://github.com/FortranGoingOnForty/fgof-state)
- [fgof-clipboard](https://github.com/FortranGoingOnForty/fgof-clipboard)
- [fgof-screen](https://github.com/FortranGoingOnForty/fgof-screen)
- [fgof-jobs](https://github.com/FortranGoingOnForty/fgof-jobs)
- [fgof-devloop](https://github.com/FortranGoingOnForty/fgof-devloop)

The current active library target is `fgof-devloop`, with `fgof-archive`
and `fgof-snapshot` close behind in the backlog.

If you want local comparison checkouts for already-served or deferred areas,
use `./scripts/sync-refs.sh` to populate `.refs/` from the curated reference
set in [docs/REFERENCE-LIBS.md](docs/REFERENCE-LIBS.md).

## Why This Structure

This repo exists to answer two different needs cleanly:

1. People should be able to land on one GitHub repo and understand the whole library family.
2. People should also be able to find, clone, star, release, and depend on one package at a time.

Git submodules are the best fit here because they preserve:

- independent package history
- independent package versioning
- independent package visibility on GitHub
- easy standalone consumption by `fpm` users

## Layout

```text
lib-modules/
  README.md
  LANDSCAPE.md
  docs/
    REPO-STRUCTURE.md
  packages/
    README.md
    fgof-process/     # git submodule
    fgof-fs/          # git submodule
    fgof-pty/         # git submodule
    fgof-lineedit/    # git submodule
    fgof-expect/      # git submodule
    fgof-proc-test/   # git submodule
    fgof-temp/        # git submodule
    fgof-cache/       # git submodule
    fgof-state/       # git submodule
    fgof-clipboard/   # git submodule
    fgof-screen/      # git submodule
    fgof-jobs/        # git submodule
    fgof-devloop/     # git submodule
    ...
  scripts/
    add-package-submodule.sh
    sync-refs.sh
```

## Package Catalog

| Package | Status | Repo Model | Notes |
| --- | --- | --- | --- |
| [`fgof-process`](https://github.com/FortranGoingOnForty/fgof-process) | released `v0.1.0` + trunk fix | standalone repo + submodule | POSIX-first process helpers, mounted at `packages/fgof-process` |
| [`fgof-fs`](https://github.com/FortranGoingOnForty/fgof-fs) | released `v0.1.0` | standalone repo + submodule | filesystem and path helpers, mounted at `packages/fgof-fs` |
| [`fgof-pty`](https://github.com/FortranGoingOnForty/fgof-pty) | released `v0.1.0` | standalone repo + submodule | POSIX-first PTY helpers, mounted at `packages/fgof-pty` |
| [`fgof-lineedit`](https://github.com/FortranGoingOnForty/fgof-lineedit) | released `v0.1.0` | standalone repo + submodule | Fortran-native line editing helpers, mounted at `packages/fgof-lineedit` |
| [`fgof-watch`](https://github.com/FortranGoingOnForty/fgof-watch) | released `v0.1.0` | standalone repo + submodule | polling-first watch helpers, mounted at `packages/fgof-watch` |
| [`fgof-termios`](https://github.com/FortranGoingOnForty/fgof-termios) | released `v0.1.0` | standalone repo + submodule | terminal mode helpers, mounted at `packages/fgof-termios` |
| [`fgof-keys`](https://github.com/FortranGoingOnForty/fgof-keys) | released `v0.1.0` | standalone repo + submodule | terminal key decoding helpers, mounted at `packages/fgof-keys` |
| [`fgof-expect`](https://github.com/FortranGoingOnForty/fgof-expect) | released `v0.1.0` | standalone repo + submodule | expect-style PTY automation helpers, mounted at `packages/fgof-expect` |
| [`fgof-proc-test`](https://github.com/FortranGoingOnForty/fgof-proc-test) | released `v0.1.0` | standalone repo + submodule | process-test fixtures, mounted at `packages/fgof-proc-test` |
| [`fgof-temp`](https://github.com/FortranGoingOnForty/fgof-temp) | released `v0.1.0` | standalone repo + submodule | temp files, temp dirs, and atomic write helpers, mounted at `packages/fgof-temp` |
| [`fgof-cache`](https://github.com/FortranGoingOnForty/fgof-cache) | released `v0.1.0` | standalone repo + submodule | disk cache helpers, mounted at `packages/fgof-cache` |
| [`fgof-state`](https://github.com/FortranGoingOnForty/fgof-state) | released `v0.1.0` | standalone repo + submodule | persistent app and workspace state helpers, mounted at `packages/fgof-state` |
| [`fgof-clipboard`](https://github.com/FortranGoingOnForty/fgof-clipboard) | released `v0.1.0` | standalone repo + submodule | clipboard text helpers, mounted at `packages/fgof-clipboard` |
| [`fgof-screen`](https://github.com/FortranGoingOnForty/fgof-screen) | released `v0.1.0` | standalone repo + submodule | virtual screen buffer helpers, mounted at `packages/fgof-screen` |
| [`fgof-jobs`](https://github.com/FortranGoingOnForty/fgof-jobs) | released `v0.1.0` | standalone repo + submodule | background job and wait-model helpers, mounted at `packages/fgof-jobs` |
| [`fgof-devloop`](https://github.com/FortranGoingOnForty/fgof-devloop) | in development, Sprint 04 | standalone repo + submodule | watch-driven development loop helpers, mounted at `packages/fgof-devloop` |

As packages are created:

- each package gets its own repository
- each package is added here under `packages/` as a submodule
- this table should be updated with its repo URL and current status

## How To Use This Repo

Clone the umbrella repo when you want the catalog, landscape docs, and package submodules together:

```bash
git clone --recurse-submodules git@github.com:FortranGoingOnForty/lib-modules.git
```

Go directly to an individual package repo when you only want one library.

## Working Rules

- Root repo holds docs, shared conventions, and package discovery.
- Package code should live in standalone repos, not directly in the root repo.
- The `packages/` directory is reserved for Git submodules and package-specific notes.
- Cross-package dependencies should stay shallow and optional.
- Every package should remain usable as a standalone `fpm` dependency.

## Current Packages

- [`fgof-process`](https://github.com/FortranGoingOnForty/fgof-process): POSIX-first process and subprocess helpers
- [`fgof-fs`](https://github.com/FortranGoingOnForty/fgof-fs): filesystem and path helpers
- [`fgof-pty`](https://github.com/FortranGoingOnForty/fgof-pty): POSIX-first PTY and terminal session helpers
- [`fgof-lineedit`](https://github.com/FortranGoingOnForty/fgof-lineedit): Fortran-native line editing helpers for interactive CLIs
- [`fgof-watch`](https://github.com/FortranGoingOnForty/fgof-watch): polling-first watch helpers for tools and dev loops
- [`fgof-termios`](https://github.com/FortranGoingOnForty/fgof-termios): terminal mode helpers for interactive tools
- [`fgof-keys`](https://github.com/FortranGoingOnForty/fgof-keys): terminal key decoding helpers for interactive tools
- [`fgof-expect`](https://github.com/FortranGoingOnForty/fgof-expect): expect-style PTY automation helpers for interactive tools and tests
- [`fgof-proc-test`](https://github.com/FortranGoingOnForty/fgof-proc-test): process-test fixtures for command-line tools and integration suites
- [`fgof-temp`](https://github.com/FortranGoingOnForty/fgof-temp): temp files, temp directories, and atomic write helpers
- [`fgof-cache`](https://github.com/FortranGoingOnForty/fgof-cache): disk cache helpers for command-line tools and local developer workflows
- [`fgof-state`](https://github.com/FortranGoingOnForty/fgof-state): persistent app and workspace state helpers
- [`fgof-clipboard`](https://github.com/FortranGoingOnForty/fgof-clipboard): clipboard text helpers for command-line and interactive tools
- [`fgof-screen`](https://github.com/FortranGoingOnForty/fgof-screen): virtual screen buffer helpers for future TUIs and prompt layers
- [`fgof-jobs`](https://github.com/FortranGoingOnForty/fgof-jobs): background job and wait-model helpers for shells, supervisors, and tool hosts
- [`fgof-devloop`](https://github.com/FortranGoingOnForty/fgof-devloop): watch-driven development loop helpers for rebuild, restart, and smoke workflows

See [LANDSCAPE.md](LANDSCAPE.md) for the broader ecosystem assessment and package backlog.
