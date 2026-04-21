# Fortran Systems Ecosystem Landscape

Date: 2026-04-21

This document is a decision aid for `FortranGoingOnForty/lib-modules`.

It is not an implementation plan, and it is not trying to survey all of Fortran. It is focused on reusable systems and tooling packages that working Fortran programmers could actually depend on for shells, terminals, editors, file tools, developer tooling, local services, and command-line applications.

The central question is not "can Fortran do this?" The central question is:

> where does the Fortran ecosystem still lack a small, dependable, ergonomic package that an application author would realistically reach for?

Package names in this document are provisional and only meant to make the backlog easier to discuss.

Candidate count: `48`

## Contents

- [Executive Summary](#executive-summary)
- [Purpose And Framing](#purpose-and-framing)
- [Ecosystem Snapshot](#ecosystem-snapshot)
- [How To Read The Scores](#how-to-read-the-scores)
- [Category Backlog](#category-backlog)
- [Organization Recommendations](#organization-recommendations)
- [Local Extraction Evidence](#local-extraction-evidence)
- [Sources Appendix](#sources-appendix)
- [Final Read](#final-read)

## Executive Summary

### What The Current Landscape Looks Like

- The official package index already has credible coverage for config and serialization formats, CLI parsing, logging, regex, ncurses bindings, raw POSIX wrappers, SQLite bindings, libcurl bindings, compression bindings, and many scientific utilities.
- `stdlib` is also expanding into general-purpose territory. Its published scope includes utilities, logging, strings, containers, and OS or environment integration, and the current `stdlib_system` spec already covers path operations plus synchronous and asynchronous process execution.
- The big gap is not "nothing exists." The big gap is that many systems-oriented areas are still split between:
  - thin bindings
  - experimental `stdlib` surfaces
  - personal utility collections
  - app-local code inside projects like `fortsh`, `fifftty`, `fortress`, `sniffert`, and `facsimile`

### Highest-Signal Conclusion

The strongest opportunity is still the same cluster:

1. filesystem ergonomics
2. subprocess and process control
3. PTY and terminal state control
4. file watching
5. archive and compression ergonomics
6. platform helpers like clipboard, "open with default app", temp files, and app-state persistence

These are the places where:

- real apps need the functionality repeatedly
- the Fortran ecosystem has pieces, but not yet an obvious default
- your own codebase already contains extractable proof that the need is real

### Top Gaps

- There is no obvious "default" app-author-friendly filesystem toolkit for Fortran even though filesystem APIs are actively being discussed and implemented in `stdlib`.
- There is no obvious default high-level subprocess library with the kind of DX people expect from Python's `subprocess`, Rust's `std::process`, or Go's `exec`.
- PTY and interactive terminal work remains very underpackaged despite being crucial for shells, terminal emulators, test harnesses, and text UIs.
- File watching looks especially under-served: there are tools around the ecosystem, but no obvious reusable Fortran library that normal app authors would pull in.
- Compression and archive support exists mostly as low-level bindings, not as a clean general-purpose package surface.
- Persistent local app state, cache management, and workspace-state helpers are still mostly hand-rolled.

### Strongest Bets Right Now

These are the best "start here" candidates if the goal is maximum ecosystem value rather than novelty for its own sake.

Scores are `Impact / Gap severity / Feasibility / Local leverage / Maintenance burden`. Lower maintenance burden is better.

| Project | Why It Stands Out | Existing Leverage | Scores | Verdict |
| --- | --- | --- | --- | --- |
| `fgof-process` | Repeated need across shells, CLIs, test tools, and editors; current options are fragmented | [fortsh system interface](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fortsh/src/system/interface.f90:1) | `5/5/4/5/3` | Strong candidate |
| `fgof-pty` | Rarely packaged well in Fortran, but essential for interactive tooling | [fifftty PTY manager](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fifftty/src/pty_manager.f90:1), `fortsh` interactive tests | `5/5/4/5/4` | Strong candidate |
| `fgof-fs` | Biggest general-purpose gap after processes; would benefit multiple app types immediately | [sniffert file system](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/sniffert/src/file_system.f90:1), [fortress filesystem ops](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fortress/src/filesystem/fs_ops.f90:1) | `5/5/4/5/3` | Strong candidate |
| `fgof-watch` | Genuine ecosystem hole; useful for dev loops, editors, sync tools, live reload | no obvious default local package yet | `5/5/3/3/4` | Strong candidate |
| `fgof-lineedit` | Shells and CLIs repeatedly need it; current options are narrow or app-local | `fortsh` readline stack, editor input work | `5/5/4/5/4` | Strong candidate |
| `fgof-keys` | Terminal key handling is a pain point that many apps re-solve badly | `fit`, `fortsh`, `facsimile` input handling | `4/5/4/4/3` | Strong candidate |
| `fgof-clipboard` | Small, very practical, and clearly underpackaged | local clipboard code in `facsimile` | `4/5/4/4/3` | Strong candidate |
| `fgof-temp` | Temp files, temp dirs, atomic writes, and safe replacement show up everywhere | `fit`, `fortress`, `facsimile` backup flows | `4/4/5/4/2` | Strong candidate |
| `fgof-cache` | Local caches are useful for tools and usually hand-written badly | `fuss` cache module, command tooling | `4/5/4/4/2` | Strong candidate |
| `fgof-state` | Workspace and session persistence is a repeated app need with no obvious default package | `facsimile` workspace vision | `4/5/5/4/2` | Strong candidate |
| `fgof-sqlite` | Bindings exist, but an ergonomic layer would be broadly useful | existing SQLite bindings in ecosystem | `4/4/4/2/3` | Strong candidate |
| `fgof-posix-core` | A curated binding layer would reduce reinvention across many future packages | `fortsh`, `sniffert`, `fit`, `fifftty` | `5/4/4/5/3` | Strong candidate |
| `fgof-devloop` | There is already `fpm-watch` as a tool, but not a reusable library surface | process and watch primitives can feed it | `4/4/5/3/2` | Strong candidate |

### Crowded Or Lower-Priority Areas

These are not "bad ideas." They are areas where you should only enter if you have a very clear differentiator.

| Area | Why It Is Lower Priority | Existing Options |
| --- | --- | --- |
| JSON | Multiple packages already exist | `json-fortran`, `FortJSON`, `jsonff` |
| TOML | Clear ecosystem option already exists | `toml-f` |
| YAML | Not empty enough to justify a me-too entry | `yaFyaml` |
| CLI parsing | Several options already cover the basics well | `FLAP`, `M_CLI` |
| Logging and errors | Active `stdlib` work plus multiple ecosystem packages | `stdlib_logger`, `erloff`, `fortran-error-handler`, `pFlogger` |
| Regex | Solid wrapper exists already | `fortran-pcre2` |
| ncurses bindings | More than one binding exists | `fortran-ncurses`, `M_ncurses` |
| Raw HTTP baseline | There is already an HTTP client plus libcurl bindings | `http-client`, `fortran-curl` |
| Raw OS wrappers | The ecosystem already has several low-level wrappers | `fortran-unix`, `M_system`, `os` |

## Purpose And Framing

This document assumes that the future `lib-modules` repo acts as an umbrella catalog repo, not a traditional monorepo:

- docs and coordination live here
- individual packages live in their own repos
- this repo can later collect them via Git submodules

That matters because it changes the target shape of good projects:

- each package should be viable as a standalone `fpm` dependency
- each package should have a clear surface area and release story
- cross-package coupling should be optional, not structural

The ideal end state is not "one giant dependency graph." It is:

- a coherent family of small packages
- consistent naming and conventions
- clear discovery from one umbrella repo
- independent adoption by people who only want one package

## Ecosystem Snapshot

### What Already Exists

The official package index shows that Fortran already has a meaningful spread of non-numerical packages:

- strings and text handling
- config and serialization formats
- logging and error handling
- CLI argument parsing
- regex
- ncurses bindings
- SQLite, LMDB, Lua, Tcl, Modbus, XMPP and other interfaces
- libcurl, zlib, zstd and POSIX wrappers

That means the right strategy is not to pretend the ecosystem is empty. The right strategy is to find the places where coverage is shallow, awkward, stale, or too low-level.

### `stdlib` Is Moving Toward This Space

`stdlib` already positions itself as a community general-purpose library, and the current docs show:

- strings and string types
- logger
- containers
- OS and subprocess APIs in `stdlib_system`

Inference: if you build in this space, the best approach is to complement `stdlib`, align where it helps, and avoid fighting it head-on in areas where it is already the natural default.

### Why Your Local Codebase Matters

Your local projects are not toy examples. They are real end-user tools:

- shell: `fortsh`
- terminal emulator: `fifftty`
- file explorer: `fortress`
- disk analyzer: `sniffert`
- editor and workspace tooling: `facsimile`
- merge tool / TUI tooling: `fit`
- tree and git helper tooling: `fuss`

Those projects repeatedly need:

- filesystem traversal and metadata
- subprocess and job control
- PTY interaction
- terminal state management
- clipboard and prompt helpers
- persistent workspace or tool state

That makes extraction-based packages unusually credible here. These are not hypothetical package ideas; they are recurring needs that have already been paid for in app code.

## How To Read The Scores

Every candidate uses the same five scores:

- `Impact`: how broadly useful this would be to app authors
- `Gap severity`: how underserved the area still looks
- `Feasibility`: how likely it is to ship something solid without heroic effort
- `Local leverage`: how much existing FortranGoingOnForty code or tests could accelerate it
- `Maintenance burden`: how expensive it will be to support over time

Interpretation:

- higher is better for `Impact`, `Gap severity`, `Feasibility`, and `Local leverage`
- lower is better for `Maintenance burden`

Verdicts:

- `Strong candidate`: worth serious consideration soon
- `Worth exploring`: promising, but needs sharper differentiation or depends on upstream choices
- `Low priority`: possible someday, but not where the leverage is right now

## Category Backlog

### 1. Filesystem And Paths

Takeaway: the ecosystem has pieces here, but not yet a clear ergonomic default for app authors.

| Project | Pitch And Problem Solved | Why The Gap Remains | Existing Options | Recommended Shape | Dependency Story | Local Leverage | Scores | Verdict |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `fgof-path` | Path type plus joins, normalize, relatives, basename, dirname, tilde and home handling | Path helpers exist, but they are either low-level or experimental rather than a polished everyday API | `stdlib_system`, `M_IO`, `M_system`, `os` | ergonomic facade | mostly pure Fortran | [fortress filesystem ops](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fortress/src/filesystem/fs_ops.f90:1), [sniffert file system](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/sniffert/src/file_system.f90:1) | `4/4/5/4/2` | Strong candidate |
| `fgof-fs` | `stat`, `lstat`, `exists`, `scandir`, `walk`, metadata, symlink handling, permissions | There are wrappers, but not an obvious small package people would confidently standardize on | `stdlib_system`, `fortran-unix`, `fortyxima`, `os` | ergonomic facade | POSIX C shim first | [fortsh system interface](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fortsh/src/system/interface.f90:1), [sniffert file system](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/sniffert/src/file_system.f90:1), [fortress filesystem ops](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fortress/src/filesystem/fs_ops.f90:1) | `5/5/4/5/3` | Strong candidate |
| `fgof-temp` | Temp files, temp dirs, atomic write or replace, safe move semantics | Almost every tool needs this and almost every tool hand-rolls it | no obvious default package surfaced in official index | new implementation | pure Fortran plus OS calls | `fit` temp-file flows, `fortress` scratch files, `facsimile` backup ideas | `4/4/5/4/2` | Strong candidate |
| `fgof-trash-open` | Trash files safely, reveal paths, open with default app, launch file manager | Very practical, clearly useful, and not obviously covered by a standard package | no obvious default package surfaced in official index | new implementation | shell or C shims by platform | [fortress filesystem ops](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fortress/src/filesystem/fs_ops.f90:1), [sniffert file system](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/sniffert/src/file_system.f90:1) | `4/5/4/4/3` | Strong candidate |
| `fgof-xdg` | Config, cache, state, runtime-dir discovery for CLI and TUI apps | Every serious app repeats this logic; existing wrappers stop at environment access | `M_system`, raw env helpers | new implementation | pure Fortran | [facsimile workspace vision](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/facsimile/docs/WORKSPACE_VISION.md:1) | `3/4/5/4/1` | Worth exploring |
| `fgof-ignore` | `.gitignore`-style rules, include or exclude filters, reusable path selection engine | Globbing is not the same as ignore semantics, and tooling authors often need the latter | local `fortsh` globbing, regex packages | extracted module or new implementation | pure Fortran | `fortsh` glob parser, `fuss` tree scanning | `4/4/4/4/2` | Worth exploring |

### 2. Processes And Jobs

Takeaway: this is one of the strongest clusters in the whole document.

| Project | Pitch And Problem Solved | Why The Gap Remains | Existing Options | Recommended Shape | Dependency Story | Local Leverage | Scores | Verdict |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `fgof-process` | High-level `run`, `spawn`, capture, timeouts, cwd, env overrides, exit status | `stdlib` and wrappers exist, but there is still no obvious ergonomic default for apps and tests | `stdlib_system`, `M_process`, `M_system`, `fortran-unix` | ergonomic facade | POSIX first with C shim | [fortsh system interface](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fortsh/src/system/interface.f90:1) and executor stack | `5/5/4/5/3` | Strong candidate |
| `fgof-cmd` | Safe argv construction and shell quoting helpers to stop command-string bugs | Command construction is still mostly hand-built strings | ad hoc code; general wrappers do not center this | new implementation | pure Fortran | `fortress` git command building, `fortsh` parser and execution model | `4/4/5/4/1` | Strong candidate |
| `fgof-env` | Environment variables, executable lookup, PATH resolution, cwd stack helpers | Existing wrappers expose pieces, but not a small opinionated convenience layer | `M_system`, `stdlib_system`, `fortran-unix` | ergonomic facade | pure Fortran plus OS calls | `fortress`, `facsimile`, `fortsh` startup logic | `3/3/5/4/1` | Worth exploring |
| `fgof-jobs` | Background jobs, process groups, wait models, pipeline status tracking | Shells need this; most general packages do not even try to expose it well | local shell code only; low-level POSIX bindings | extracted module | POSIX only at first | `fortsh` jobs and signal handling | `4/5/3/5/4` | Strong candidate |
| `fgof-proc-test` | Test fixtures for child processes, retry loops, cleanup, capture, fail-fast helpers | General test frameworks exist, but process-fixture tooling is thin | `test-drive`, `vegetables`, `pFUnit` do not specialize here | new implementation | `fgof-process` backend | `fortsh` integration tests and runner logic | `4/5/4/5/3` | Strong candidate |

### 3. PTY And Terminal Control

Takeaway: this is unusually underpackaged given how important it is for interactive tools.

| Project | Pitch And Problem Solved | Why The Gap Remains | Existing Options | Recommended Shape | Dependency Story | Local Leverage | Scores | Verdict |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `fgof-pty` | PTY sessions, child attach, reads and writes, resize, close, signal delivery | This capability is critical for shells and terminals but still mostly app-local | no obvious general-purpose default in official index | extracted module or ergonomic facade | POSIX C shim | [fifftty PTY manager](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fifftty/src/pty_manager.f90:1), `fortsh` interactive harnesses | `5/5/4/5/4` | Strong candidate |
| `fgof-termios` | Raw and canonical mode guards, echo restore, cursor restore safety | Terminal mode handling is low-level and error-prone | `fortran-unix` and raw POSIX only | ergonomic facade | POSIX C shim | [fortsh system interface](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fortsh/src/system/interface.f90:1), `fit` keyboard handling | `4/4/5/5/2` | Strong candidate |
| `fgof-ttysize` | Terminal size querying, resize propagation, helper APIs for UI layouts | This logic appears all over interactive tools, but rarely as a standalone package | low-level ioctl wrappers only | small utility package | POSIX first | `fortsh`, `fifftty`, `fit` terminal sizing code | `3/4/5/4/2` | Worth exploring |
| `fgof-expect` | Expect-style PTY testing library for scripted interactions | Great fit for shells, TUIs, terminal apps, and CI; ecosystem surface is tiny | no obvious general-purpose default in official index | new implementation | `fgof-pty` backend | `fortsh` interactive YAML specs, `fifftty` tests | `4/5/4/5/3` | Strong candidate |

### 4. Terminal UX And TUI Primitives

Takeaway: the ecosystem has low-level pieces, but a lot of day-to-day TUI ergonomics are still hand-built.

| Project | Pitch And Problem Solved | Why The Gap Remains | Existing Options | Recommended Shape | Dependency Story | Local Leverage | Scores | Verdict |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `fgof-ansi` | Styles, cursor movement, alternate screen, clear regions, restore helpers | ANSI codes exist in `stdlib`, but many apps still want a friendlier composition layer | `stdlib_ansi`, app-local snippets | ergonomic facade | pure Fortran | `fortsh`, `facsimile`, `fortress`, `fit` | `3/3/5/5/1` | Worth exploring |
| `fgof-keys` | Normalize escape sequences and terminal key decoding across terminals | Everyone reinvents this differently, and it is brittle | ncurses or custom parsing; no obvious standalone default | new implementation | pure Fortran plus termios helpers | `fit`, `fortsh`, `facsimile` input work | `4/5/4/4/3` | Strong candidate |
| `fgof-lineedit` | History, kill/yank, completion hooks, prompt editing for CLI tools | Readline integration exists, but a clean Fortran-native line editor surface is still rare | local readline wrappers, `M_history` | extracted module or new implementation | termios plus terminal I/O | `fortsh` I/O stack, editor input ideas | `5/5/4/5/4` | Strong candidate |
| `fgof-clipboard` | Cross-platform clipboard get and set for text tools | Small but useful package with clear practical demand | no obvious default package in official index | extracted module | shell tools by platform | `facsimile` clipboard module | `4/5/4/4/3` | Strong candidate |
| `fgof-prompt` | Menus, confirm prompts, pickers, spinners, progress, forms | Useful to many CLI and TUI tools, but usually bolted onto apps | CLI parsers cover args, not interactive prompts | new implementation | pure Fortran | `fortress` UI, `sniffert` UI, `fit` TUI layout | `3/4/4/4/2` | Worth exploring |
| `fgof-screen` | Virtual screen buffer and diff renderer for TUIs | ncurses bindings exist, but a higher-level compositional model does not clearly dominate | `fortran-ncurses`, `M_ncurses` | ergonomic facade | can sit on ANSI or ncurses | `sniffert` terminal UI, `fifftty` terminal grid, `facsimile` rendering code | `4/4/3/4/4` | Worth exploring |

### 5. Filesystem Watching

Takeaway: this is one of the clearest "library gap" areas in the whole document.

| Project | Pitch And Problem Solved | Why The Gap Remains | Existing Options | Recommended Shape | Dependency Story | Local Leverage | Scores | Verdict |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `fgof-watch` | High-level watch API with native backends and polling fallback | There are tools and external libraries, but no obvious reusable Fortran default for app authors | `fpm-watch` is a tool, not a library; no obvious package-index default | ergonomic facade | native backends via C or libfswatch | future editor and dev-loop use across local tools | `5/5/3/3/4` | Strong candidate |
| `fgof-watch-poll` | Pure polling backend for portability, CI, and fallback behavior | Native watchers are complex; polling still has value as a reliable baseline | no obvious package-index default | new implementation | pure Fortran | useful for any future watch-based package | `3/4/5/2/2` | Worth exploring |
| `fgof-watch-rules` | Ignore rules, debounce, coalescing, event filtering | Real watchers need event shaping; many libraries stop at raw notifications | app authors usually reimplement this themselves | library sidecar | pure Fortran | combines well with `fgof-ignore` and `fgof-watch` | `3/4/4/2/2` | Worth exploring |
| `fgof-devloop` | Auto restart and rebuild supervision library for tools and tests | There is visible demand for watch-driven dev loops, but the reusable library layer is missing | `fpm-watch` as a tool | new implementation | `fgof-watch` plus `fgof-process` | useful for local tool development and CI smoke loops | `4/4/5/3/2` | Strong candidate |

### 6. Networking And Services

Takeaway: this space is not empty, but it is still mostly thin bindings plus isolated projects.

| Project | Pitch And Problem Solved | Why The Gap Remains | Existing Options | Recommended Shape | Dependency Story | Local Leverage | Scores | Verdict |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `fgof-http` | Friendlier HTTP client with requests, headers, forms, timeouts, and composable responses | HTTP exists, but ecosystem default status and ergonomics still look unsettled | `http-client`, `fortran-curl` | ergonomic facade | libcurl backend likely | useful to future package tooling and local service clients | `4/3/4/2/3` | Worth exploring |
| `fgof-url` | URL parsing, joining, encoding, decoding, query building | Useful even outside HTTP, and not clearly solved by a common package | no obvious default package surfaced in official index | new implementation | pure Fortran | can support HTTP and service tooling later | `3/4/5/1/1` | Worth exploring |
| `fgof-tcp` | Simple TCP client or server API for tools and local services | Package-index coverage looks more demo-like and binding-like than ergonomic | `tcp-client-server`, `fortran-unix` | ergonomic facade | POSIX sockets or C shim | could support future dev tools and editor integrations | `4/4/4/2/3` | Worth exploring |
| `fgof-tls` | Secure socket helpers, certificate loading, client defaults | Important, but hard and expensive, especially cross-platform | raw OpenSSL world only | thin binding first, if at all | OpenSSL or similar | little local leverage yet | `4/5/2/1/5` | Low priority |
| `fgof-websocket` | WebSocket client for live tools, streaming APIs, and dashboards | No obvious Fortran default surfaced in official package landscape | no obvious package-index default | new implementation | handshake, framing, and likely TLS | little local leverage yet | `4/5/2/1/5` | Low priority |
| `fgof-service` | Daemon or service lifecycle helpers, pidfile, signal glue, status checks | A niche but useful layer for people writing long-running local services | process libraries expose pieces, not a full shape | new implementation | `fgof-process` and signals | `fortsh` signal and job work | `3/4/4/3/3` | Worth exploring |

### 7. Storage And Local Data

Takeaway: bindings exist here; ergonomic local-tool persistence packages mostly do not.

| Project | Pitch And Problem Solved | Why The Gap Remains | Existing Options | Recommended Shape | Dependency Story | Local Leverage | Scores | Verdict |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `fgof-sqlite` | Friendly query and transaction layer on top of SQLite bindings | SQLite bindings exist, but the "pleasant to use in an app" layer is still open | `fortran-sqlite3`, `sqliteff` | ergonomic facade | SQLite C library | future workspace, cache, and metadata tooling | `4/4/4/2/3` | Strong candidate |
| `fgof-kv` | Tiny embedded key-value store API backed by SQLite or LMDB | Tool authors often want simple persistence, not a full SQL surface | `fortran-lmdb` is low-level | ergonomic facade | SQLite or LMDB backend | can power caches and tool state | `4/4/4/2/3` | Worth exploring |
| `fgof-cache` | Disk cache with content hashing, TTLs, invalidation, and cleanup | Extremely useful for CLI tools and build-ish workflows; mostly hand-rolled today | no obvious default package surfaced in official index | new implementation | pure plus filesystem helpers | `fuss` cache ideas and tooling workflows | `4/5/4/4/2` | Strong candidate |
| `fgof-state` | Persistent app, session, and workspace state with atomic saves and versioning | Editors, shells, and file tools need this repeatedly, and config parsers alone do not solve it | config packages exist, but not a state-management default | new implementation | pure plus filesystem helpers | [facsimile workspace vision](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/facsimile/docs/WORKSPACE_VISION.md:1) | `4/5/5/4/2` | Strong candidate |

### 8. Archives And Compression

Takeaway: low-level coverage exists, but the package-author-friendly layer still looks open.

| Project | Pitch And Problem Solved | Why The Gap Remains | Existing Options | Recommended Shape | Dependency Story | Local Leverage | Scores | Verdict |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `fgof-archive` | Single high-level API for tar and zip style archive creation and extraction | Compression bindings exist, but not an obvious archive package people would instinctively use | `fortran-zlib`, `fortran-zstd` are lower-level | ergonomic facade | `libarchive` or bespoke backends | useful across packaging and artifact tools | `4/5/3/1/4` | Strong candidate |
| `fgof-compress` | Simple gzip and zstd compress/decompress functions and streams | The raw bindings are not the same thing as a pleasant package surface | `fortran-zlib`, `fortran-zstd` | ergonomic facade | zlib or zstd backend | would support archives and caching | `4/4/4/1/3` | Worth exploring |
| `fgof-checksum` | File and buffer digests for SHA-256 or similar | Great utility layer for caches, archives, snapshots, and integrity checks | no obvious package-index default surfaced | new implementation | C crypto backend likely | cross-cutting utility for many later packages | `3/4/4/1/3` | Worth exploring |
| `fgof-pack` | Bundle manifests plus files into reproducible tool artifacts | Useful for release tooling and app bundles, but more specialized than base archive work | no obvious package-index default surfaced | new implementation | archive plus checksum backends | future release and packaging workflows | `3/3/3/1/3` | Worth exploring |

### 9. Developer Tooling

Takeaway: this is fertile ground because tooling libraries often have high leverage and lower platform pain.

| Project | Pitch And Problem Solved | Why The Gap Remains | Existing Options | Recommended Shape | Dependency Story | Local Leverage | Scores | Verdict |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `fgof-snapshot` | Snapshot or golden-file testing helpers for CLIs and diagnostics | Existing test frameworks do not specialize in this workflow | `test-drive`, `vegetables`, `pFUnit` | new implementation | pure Fortran | snapshot-like local tests in `armfortas` and CLI tools | `4/5/5/3/2` | Strong candidate |
| `fgof-fixture` | Temp project, temp worktree, and fixture builders for tests | Process-heavy tools need better test fixtures than raw shell setup | general test frameworks exist, but not this niche | new implementation | filesystem plus process helpers | `fortsh`, `fit`, and other test suites | `4/4/5/3/2` | Strong candidate |
| `fgof-parser` | General parser combinators and token-stream library | Parsers exist, but reusable general parser infrastructure is still thin | `parff`, equation parsers | new implementation or extracted core | pure Fortran | `fortsh` parser stack is strong evidence | `4/4/4/5/3` | Strong candidate |
| `fgof-modulegraph` | Build module-dependency graph for Fortran source trees | Useful for tooling and editors; current options are more tool-like than library-like | `FortranCallGraph`, `fortls`, external parsers | new implementation | pure Fortran | future workspace tooling in `facsimile` | `3/4/4/2/2` | Worth exploring |
| `fgof-trace` | Structured timing and tracing spans for CLIs, tests, and services | Logging exists, but trace-style instrumentation is still sparse | `stdlib_logger`, `coretran`, `pFlogger` | new implementation | pure Fortran | `fortsh` performance helpers | `3/3/5/3/1` | Worth exploring |

### 10. Interop And Bindings

Takeaway: low-level wrappers are not glamorous, but a few carefully chosen ones could unlock many higher-level packages.

| Project | Pitch And Problem Solved | Why The Gap Remains | Existing Options | Recommended Shape | Dependency Story | Local Leverage | Scores | Verdict |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `fgof-posix-core` | Curated POSIX core for files, dirs, fd I/O, processes, signals, and terminals | Low-level wrappers exist, but coverage and naming are inconsistent and often not shaped for reuse | `fortran-unix`, `M_system`, `os` | thin binding with sane naming | POSIX C APIs | [fortsh system interface](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fortsh/src/system/interface.f90:1), [sniffert file system](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/sniffert/src/file_system.f90:1), [fifftty PTY manager](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fifftty/src/pty_manager.f90:1) | `5/4/4/5/3` | Strong candidate |
| `fgof-cstr` | Safe C-string, argv, and buffer conversion helpers for `iso_c_binding` work | Every wrapper package ends up reinventing this small but annoying layer | raw `iso_c_binding` plus scattered discourse advice | thin utility package | pure Fortran | nearly every local C-interop-heavy repo | `4/4/5/5/1` | Strong candidate |
| `fgof-libfswatch` | Thin binding to `libfswatch` for future watcher packages | Useful enabler, but not the highest-value user-facing package by itself | no obvious Fortran binding surfaced in official package index | thin binding | external `libfswatch` | prerequisite for some watch strategies | `3/4/3/1/4` | Worth exploring |
| `fgof-openssl-bind` | Thin OpenSSL binding foundation for TLS and hashing | Potentially useful, but expensive and fiddly to support well | no obvious general-purpose Fortran binding surfaced in official package index | thin binding | OpenSSL | little local leverage today | `4/5/2/1/5` | Low priority |

## Organization Recommendations

### Recommended Repo Shape

Use `lib-modules` as an umbrella repo:

```text
lib-modules/
  LANDSCAPE.md
  packages/
    fgof-fs/         # git submodule
    fgof-process/    # git submodule
    fgof-pty/        # git submodule
    ...
```

This is not a classic monorepo. It is better described as:

- a catalog repo
- shared docs and roadmap
- independent package repos collected via Git submodules

That choice fits your stated organizational preference and keeps package adoption simple for outsiders.

### Independent Package Defaults

Every serious package should aim to be:

- its own repository
- its own `fpm` package
- independently versioned
- independently releasable
- independently listable in the Fortran package index

### Naming Recommendations

Use a consistent prefix to avoid module collisions.

Provisional recommendation:

- repo names: `fgof-fs`, `fgof-process`, `fgof-pty`
- top-level module prefix: `fgof_`

Example:

- repo: `fgof-process`
- modules: `fgof_process`, `fgof_process_types`, `fgof_process_test`

### Release And Dependency Recommendations

- keep packages standalone by default
- avoid cross-package dependencies until a real need appears
- if cross-package dependencies become useful, prefer a shallow graph:
  - foundational packages first
  - ergonomic facades on top
- give each package:
  - `README.md`
  - examples
  - tests
  - CI
  - explicit compiler support notes

### Practical Sequencing

If you decide to build from this document later, the most sensible first-wave sequence looks like:

1. `fgof-posix-core`
2. `fgof-fs`
3. `fgof-process`
4. `fgof-pty`
5. `fgof-lineedit` or `fgof-watch`

That sequence maximizes reuse and minimizes duplicate low-level work.

## Local Extraction Evidence

These local files are especially strong signals that the package surface is not hypothetical:

- [fortsh system interface](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fortsh/src/system/interface.f90:1)
- [fifftty PTY manager](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fifftty/src/pty_manager.f90:1)
- [fortress filesystem ops](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fortress/src/filesystem/fs_ops.f90:1)
- [sniffert file system](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/sniffert/src/file_system.f90:1)
- [facsimile workspace vision](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/facsimile/docs/WORKSPACE_VISION.md:1)
- [facsimile fortress integration plan](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/facsimile/docs/fortress_integration.md:1)

Inference from those files:

- filesystem and path handling recur across multiple apps
- terminal state and PTY handling are already deep enough locally to extract
- workspace state, config locations, prompts, and app-state persistence are not theoretical needs
- integration tests for interactive tools could directly benefit from reusable PTY and process-test packages

## Sources Appendix

### Official Ecosystem Sources

- [Fortran package index](https://fortran-lang.org/packages/)
- [General libraries](https://fortran-lang.org/packages/libraries/)
- [I/O packages](https://fortran-lang.org/packages/io/)
- [Interface packages](https://fortran-lang.org/packages/interfaces/)
- [Programming utilities](https://fortran-lang.org/packages/programming/)
- [String libraries](https://fortran-lang.org/packages/strings/)
- [Data-type libraries](https://fortran-lang.org/packages/data-types/)

### `stdlib` Sources

- [Fortran stdlib landing page](https://stdlib.fortran-lang.org/)
- [Fortran stdlib specs index](https://stdlib.fortran-lang.org/page/specs/index.html)
- [Fortran stdlib system spec](https://stdlib.fortran-lang.org/page/specs/stdlib_system.html)
- [Fortran stdlib logger spec](https://stdlib.fortran-lang.org/page/specs/stdlib_logger.html)

### Community Discussions And Announcements

- [Stdlib system interaction API: call for feedback](https://fortran-lang.discourse.group/t/stdlib-system-interaction-api-call-for-feedback/9037)
- [GSoC '25: stdlib filesystem](https://fortran-lang.discourse.group/t/gsoc-25-stdlib-filesystem/9798)
- [GSOC Intro - stdlib File system library, OS processes](https://fortran-lang.discourse.group/t/gsoc-intro-stdlib-file-system-library-os-processes/9295)
- [GSoC 2026 Introduction: interested in stdlib file system library](https://fortran-lang.discourse.group/t/gsoc-2026-introduction-jatin-kumar-interested-in-stdlib-file-system-library/10712)
- [New Release of http-client](https://fortran-lang.discourse.group/t/new-release-of-http-client-enhancing-http-requests-in-fortran/6407)
- [Troubleshooting dependency issues with http-client](https://fortran-lang.discourse.group/t/troubleshooting-dependency-issues-with-http-client-in-fpm-projects-resolving-stdlib-optval-error/6196)
- [New fpm Plugin: fpm-watch](https://fortran-lang.discourse.group/t/new-fpm-plugin-fpm-watch/10753)
- [Will the Fortran Community participate at GSoC 2024?](https://fortran-lang.discourse.group/t/will-the-fortran-community-participate-at-gsoc-2024/7266)

### Local Evidence

- [fortsh README](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fortsh/README.md:1)
- [facsimile README](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/facsimile/README.md:1)
- [fortress README](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fortress/README.md:1)
- [fifftty README](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fifftty/README.md:1)
- [fuss README](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fuss/README.md:1)
- [fit README](/Users/mfwolffe/GithubOrgs/FortranGoingOnForty/fit/README.md:1)

## Final Read

If the goal is to close one of the most visible non-numerical gaps in the Fortran ecosystem, the best lane is not "write a random library." It is:

- extract and harden the systems layers your apps already need
- package them so they stand alone cleanly
- prefer ergonomic facades where the ecosystem already has low-level coverage
- avoid crowded categories unless you have a very sharp differentiator

The practical center of gravity remains:

- filesystem
- process control
- PTY and terminal control
- watch or dev-loop tooling
- persistence and local app state

That is the area where Fortran still looks most ready for a coherent family of packages rather than one more isolated project.
