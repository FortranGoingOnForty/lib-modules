#!/bin/sh

set -eu

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "usage: $0 <repo-url> [package-name]" >&2
  exit 1
fi

repo_url=$1

if [ "$#" -eq 2 ]; then
  package_name=$2
else
  package_name=$(basename "$repo_url")
  package_name=${package_name%.git}
fi

target_dir="packages/$package_name"

if [ -e "$target_dir" ]; then
  echo "error: target already exists: $target_dir" >&2
  exit 1
fi

git submodule add "$repo_url" "$target_dir"
echo "added submodule at $target_dir"
