#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REF_DIR="${ROOT_DIR}/.refs"

clone_or_update() {
  local group="$1"
  local name="$2"
  local url="$3"
  local target="${REF_DIR}/${group}/${name}"

  mkdir -p "${REF_DIR}/${group}"

  if [[ -d "${target}/.git" ]]; then
    echo "Updating ${group}/${name}"
    git -C "${target}" fetch --all --tags --prune
    git -C "${target}" pull --ff-only
  else
    echo "Cloning ${group}/${name}"
    git clone "${url}" "${target}"
  fi
}

clone_or_update "stdlib" "stdlib" "https://github.com/fortran-lang/stdlib.git"

clone_or_update "terminal-ui" "fortran-ncurses" \
  "https://github.com/interkosmos/fortran-ncurses.git"
clone_or_update "terminal-ui" "M_ncurses" \
  "https://github.com/urbanjost/M_ncurses.git"

clone_or_update "system" "M_process" \
  "https://github.com/urbanjost/M_process.git"
clone_or_update "system" "M_system" \
  "https://github.com/urbanjost/M_system.git"
clone_or_update "system" "fortran-unix" \
  "https://github.com/interkosmos/fortran-unix.git"

clone_or_update "testing" "test-drive" \
  "https://github.com/fortran-lang/test-drive.git"
clone_or_update "testing" "vegetables" \
  "https://github.com/everythingfunctional/vegetables.git"
