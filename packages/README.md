# Packages

This directory is reserved for package repositories added as Git submodules.

Each subdirectory here should be a standalone library repo, for example:

```text
packages/fgof-process
packages/fgof-fs
packages/fgof-pty
packages/fgof-lineedit
packages/fgof-watch
packages/fgof-termios
packages/fgof-keys
packages/fgof-expect
packages/fgof-proc-test
packages/fgof-temp
packages/fgof-cache
packages/fgof-state
packages/fgof-clipboard
packages/fgof-screen
packages/fgof-jobs
packages/fgof-devloop
```

Current submodules:

- `fgof-process`
- `fgof-fs`
- `fgof-pty`
- `fgof-lineedit`
- `fgof-watch`
- `fgof-termios`
- `fgof-keys`
- `fgof-expect`
- `fgof-proc-test`
- `fgof-temp`
- `fgof-cache`
- `fgof-state`
- `fgof-clipboard`
- `fgof-screen`
- `fgof-jobs`
- `fgof-devloop`

Rules:

- do not create root-owned package source trees directly in this directory
- create each package as its own repo first
- then add it here as a submodule

That keeps each package independently discoverable and releasable.
