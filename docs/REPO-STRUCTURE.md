# Repo Structure

This document defines how `lib-modules` is organized.

## Repository Type

`lib-modules` is an umbrella repo, not a traditional shared-history monorepo.

Use this repo for:

- landscape and roadmap docs
- package discovery
- shared naming and release conventions
- Git submodule pointers to package repos

Do not use this repo as the place where package source code is primarily developed.

## Package Model

Each reusable library should have:

- its own GitHub repository
- its own `fpm.toml`
- its own release tags
- its own CI
- its own issue tracker
- its own README and examples

This repo then includes that package repo as a Git submodule at:

```text
packages/<package-name>
```

Examples:

```text
packages/fgof-process
packages/fgof-fs
packages/fgof-pty
```

## Why Submodules Instead Of A Flat `packages/` Code Monorepo

Submodules are the preferred structure here because they preserve the things that matter most for reusable libraries:

- package-level discoverability on GitHub
- clean standalone clone URLs
- independent commit history
- independent release cadence
- easier mental model for outside users

The main downside is submodule workflow friction. That is acceptable here because this root repo is mostly a catalog and coordination layer, not the main day-to-day development surface for every package.

## Naming Conventions

Recommended package naming:

- repo names: `fgof-process`, `fgof-fs`, `fgof-pty`
- top-level module prefix: `fgof_`

Examples:

- repo: `fgof-process`
- modules: `fgof_process`, `fgof_process_types`

## Root Repo Contents

Root-level files should stay focused on:

- high-signal docs
- package index or catalog
- contributor guidance for the umbrella
- small helper scripts for submodule management

Good root-level files:

- `README.md`
- `LANDSCAPE.md`
- `docs/REPO-STRUCTURE.md`
- `scripts/add-package-submodule.sh`

Avoid placing package implementation files directly at the root.

## Adding A New Package

Recommended flow:

1. Create the package as its own repository.
2. Give it a minimal standalone structure:
   - `fpm.toml`
   - `src/`
   - `test/`
   - `README.md`
   - CI
3. Add it here as a submodule under `packages/`.
4. Update the root `README.md` package catalog.
5. Add any package-specific notes or cross-links if needed.

## Cross-Package Dependencies

Prefer:

- standalone packages first
- shallow dependency graph
- shared conventions over shared internal code

Avoid:

- tight internal coupling between packages
- hidden assumptions that a package is always checked out inside this umbrella repo

Every package should make sense to someone who finds it on GitHub without ever opening `lib-modules`.
