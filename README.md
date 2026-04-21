# FortranGoingOnForty Lib Modules

This repository is the umbrella catalog for reusable Fortran packages developed under the `FortranGoingOnForty` umbrella.

It is intentionally not a traditional code monorepo.

The goal is:

- keep shared docs, roadmap, and package discovery in one place
- keep each package in its own repository with its own history, releases, issues, and CI
- collect those package repos here as Git submodules under `packages/`

That gives us the discoverability and organization benefits of one home page without burying every package inside a giant top-level repo.

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
    ...
  scripts/
    add-package-submodule.sh
```

## Package Catalog

| Package | Status | Repo Model | Notes |
| --- | --- | --- | --- |
| `fgof-process` | scaffolded | standalone repo + submodule | first package target, mounted at `packages/fgof-process` |

As packages are created:

- each package gets its own repository
- each package is added here under `packages/` as a submodule
- this table should be updated with its repo URL and current status

## Working Rules

- Root repo holds docs, shared conventions, and package discovery.
- Package code should live in standalone repos, not directly in the root repo.
- The `packages/` directory is reserved for Git submodules and package-specific notes.
- Cross-package dependencies should stay shallow and optional.
- Every package should remain usable as a standalone `fpm` dependency.

## First Package

The first package planned for this umbrella is `fgof-process`, a POSIX-first process and subprocess library for modern Fortran applications.

See [LANDSCAPE.md](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/lib-modules/LANDSCAPE.md:1) for the broader ecosystem assessment and package backlog.
