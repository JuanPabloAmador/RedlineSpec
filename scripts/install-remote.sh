#!/usr/bin/env bash
set -euo pipefail

print_help() {
  cat <<'EOF'
RedlineSpec remote installer

Usage:
  curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh | bash -s -- [TARGET_PATH] [install options]

Examples:
  curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh | bash -s -- --harness pi
  curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh | bash -s -- ~/work/my-project --harness opencode
  REDLINESPEC_REF=v0.2.0 curl -fsSL https://raw.githubusercontent.com/JuanPabloAmador/RedlineSpec/main/scripts/install-remote.sh | bash -s -- --harness opencode

Environment:
  REDLINESPEC_REPO_URL  GitHub repository URL. Default: https://github.com/JuanPabloAmador/RedlineSpec
  REDLINESPEC_REF       Branch, tag, or commit to download. Default: main

Behavior:
  - Downloads a temporary RedlineSpec source archive from GitHub.
  - Runs the normal scripts/install.sh from that archive.
  - If TARGET_PATH is omitted or the first argument is an option, installs into the current directory.
EOF
}

log() {
  printf '[redline-remote-install] %s\n' "$1"
}

fail() {
  printf '[redline-remote-install] ERROR: %s\n' "$1" >&2
  exit 1
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  print_help
  exit 0
fi

REPO_URL="${REDLINESPEC_REPO_URL:-https://github.com/JuanPabloAmador/RedlineSpec}"
REF="${REDLINESPEC_REF:-main}"

TARGET_PATH=""
if [[ $# -eq 0 || "${1:-}" == --* ]]; then
  TARGET_PATH="."
else
  TARGET_PATH="$1"
  shift
fi

command -v curl >/dev/null 2>&1 || fail "curl is required."
command -v tar >/dev/null 2>&1 || fail "tar is required."

case "$REPO_URL" in
  https://github.com/*)
    repo_path="${REPO_URL#https://github.com/}"
    repo_path="${repo_path%.git}"
    ;;
  git@github.com:*)
    repo_path="${REPO_URL#git@github.com:}"
    repo_path="${repo_path%.git}"
    ;;
  *)
    fail "Only GitHub repository URLs are supported by the remote installer: $REPO_URL"
    ;;
esac

archive_url="https://codeload.github.com/${repo_path}/tar.gz/${REF}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

archive="$tmp_dir/redlinespec.tar.gz"
extract_dir="$tmp_dir/src"
mkdir -p "$extract_dir"

log "Downloading RedlineSpec ${REF} from ${REPO_URL}"
curl -fsSL "$archive_url" -o "$archive" || fail "Failed to download archive: $archive_url"

tar -xzf "$archive" -C "$extract_dir" || fail "Failed to extract downloaded archive."

source_root="$(find "$extract_dir" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
[[ -n "$source_root" ]] || fail "Downloaded archive did not contain a source directory."
[[ -f "$source_root/scripts/install.sh" ]] || fail "Downloaded archive does not contain scripts/install.sh."

log "Installing into: $TARGET_PATH"
bash "$source_root/scripts/install.sh" "$TARGET_PATH" "$@"
