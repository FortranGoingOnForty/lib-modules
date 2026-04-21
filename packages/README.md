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
```

Current submodules:

- `fgof-process`
- `fgof-fs`
- `fgof-pty`
- `fgof-lineedit`
- `fgof-watch`
- `fgof-termios`

Rules:

- do not create root-owned package source trees directly in this directory
- create each package as its own repo first
- then add it here as a submodule

That keeps each package independently discoverable and releasable.
