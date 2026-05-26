#!/usr/bin/env bash
set -euo pipefail

print_help() {
  cat <<'EOF'
RedlineSpec installer

Usage:
  bash scripts/install.sh TARGET_PATH [--update] [--update-system] [--harness opencode[,windsurf]]... [--update-harness]

Behavior:
  - TARGET_PATH is required and must point to the destination project repository.
  - This RedlineSpec repository is the source of the installer assets and should stay separate from the destination repository.
  - Creates the canonical .redline/ layout inside the target repository.
  - Copies distributed templates into .redline/system/templates/.
  - Requires a harness selection for installs, either through --harness or an interactive terminal prompt.
  - In --update mode, detects already installed harness bindings automatically.
  - Copies skills only into harness-visible directories for the selected harnesses.
  - Bootstraps .redline/project/functional-truth/functional.index.md from the canonical template if missing.
  - Bootstraps .redline/project/rules/rules.index.md from the canonical template if missing.
  - Does not create any spec/plan/tasks change artifacts.

Options:
  --update          Refresh .redline/system/templates/ and all detected installed harness bindings.
                    Does not install new harnesses.
  --update-system   Refresh .redline/system/templates/ from this RedlineSpec repo.
                    This may overwrite existing framework-managed template files under .redline/system/templates/.
  --harness NAME    Install harness bindings. Supported values: opencode, windsurf.
                    May be repeated or passed as a comma-separated list.
                    Harness installation copies skills to native harness skill directories and installs launchers.
                    If omitted in an interactive terminal, the installer prompts for a harness.
                    If omitted in a non-interactive shell, installation fails.
  --update-harness  Refresh RedlineSpec-managed harness skills and launchers.
                    If --harness is omitted, refreshes all detected installed harnesses.
  -h, --help        Show this help.
EOF
}

log() {
  printf '[redline-install] %s\n' "$1"
}

fail() {
  printf '[redline-install] ERROR: %s\n' "$1" >&2
  exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

UPDATE_SYSTEM=0
UPDATE_HARNESS=0
TARGET_PATH=""
SELECTED_HARNESSES=""
SUPPORTED_HARNESSES="opencode windsurf"

is_supported_harness() {
  local candidate supported
  candidate="$1"
  for supported in $SUPPORTED_HARNESSES; do
    [[ "$supported" == "$candidate" ]] && return 0
  done
  return 1
}

harness_count() {
  set -- $SELECTED_HARNESSES
  printf '%s\n' "$#"
}

add_harness() {
  local candidate existing
  candidate="$1"
  is_supported_harness "$candidate" || fail "Unsupported harness: $candidate. Supported values: $SUPPORTED_HARNESSES."
  for existing in $SELECTED_HARNESSES; do
    [[ "$existing" == "$candidate" ]] && return 0
  done
  if [[ -z "$SELECTED_HARNESSES" ]]; then
    SELECTED_HARNESSES="$candidate"
  else
    SELECTED_HARNESSES="$SELECTED_HARNESSES $candidate"
  fi
}

add_harness_selection() {
  local selection item
  selection="${1//,/ }"
  for item in $selection; do
    add_harness "$item"
  done
}

prompt_for_harness() {
  local choice item selected_count selected_before

  if [[ ! -t 0 || ! -t 1 ]]; then
    fail "Harness selection is required. Pass --harness opencode, --harness windsurf, or repeat --harness for multiple harnesses."
  fi

  printf '\nSelect RedlineSpec harness bindings to install. Use comma-separated numbers for multiple choices.\n'
  printf '  1) opencode\n'
  printf '  2) windsurf\n'

  while true; do
    printf 'Harnesses [1,2]: '
    read -r choice
    selected_count="$(harness_count)"
    selected_before="$SELECTED_HARNESSES"
    choice="${choice//,/ }"
    for item in $choice; do
      case "$item" in
        1|opencode)
          add_harness opencode
          ;;
        2|windsurf)
          add_harness windsurf
          ;;
        *)
          printf 'Invalid selection: %s. Choose 1, 2, or both as 1,2.\n' "$item" >&2
          SELECTED_HARNESSES="$selected_before"
          continue 2
          ;;
      esac
    done
    if [[ "$(harness_count)" -gt "$selected_count" ]]; then
      return 0
    fi
    printf 'Select at least one harness.\n' >&2
  done
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --update)
      UPDATE_SYSTEM=1
      UPDATE_HARNESS=1
      shift
      ;;
    --update-system)
      UPDATE_SYSTEM=1
      shift
      ;;
    --update-harness)
      UPDATE_HARNESS=1
      shift
      ;;
    --harness)
      if [[ $# -lt 2 ]]; then
        fail "--harness requires a value: opencode or windsurf. Repeat the flag or use commas for multiple harnesses."
      fi
      add_harness_selection "$2"
      shift 2
      ;;
    -h|--help)
      print_help
      exit 0
      ;;
    *)
      if [[ -n "$TARGET_PATH" ]]; then
        fail "Only one target path may be provided."
      fi
      TARGET_PATH="$1"
      shift
      ;;
  esac
done

if [[ -z "$TARGET_PATH" ]]; then
  print_help
  fail "TARGET_PATH is required. Pass the destination project repository explicitly."
fi

if [[ ! -d "$TARGET_PATH" ]]; then
  fail "Target path does not exist or is not a directory: $TARGET_PATH"
fi

TARGET_DIR="$(cd "$TARGET_PATH" && pwd)"

TEMPLATES_SOURCE="$REPO_ROOT/templates"
SKILLS_SOURCE_A="$REPO_ROOT/skills"
SKILLS_SOURCE_B="$REPO_ROOT/redline-skills"
HARNESSES_SOURCE="$REPO_ROOT/harnesses"
FUNCTIONAL_TEMPLATE_SOURCE="$REPO_ROOT/templates/functional.index.template.md"
RULES_INDEX_TEMPLATE_SOURCE="$REPO_ROOT/templates/rules.index.template.md"
REQUIRED_TEMPLATES=(
  spec.template.md
  plan.template.md
  tasks.template.md
  task.template.md
  functional.index.template.md
  functional.entry.template.md
  functional.global.entry.template.md
  rules.index.template.md
  rule.template.md
)
REQUIRED_SKILLS=(
  interview-first
  write-spec
  redlinespec-spec-authoring
  write-plan
  write-tasks
  write-rules
  implement
  bootstrap-functional-truth
  close-spec
  merge-functional-truth
)

[[ -d "$TEMPLATES_SOURCE" ]] || fail "Missing templates source directory: $TEMPLATES_SOURCE"
[[ -d "$SKILLS_SOURCE_A" ]] || fail "Missing skills source directory: $SKILLS_SOURCE_A"
[[ -d "$SKILLS_SOURCE_B" ]] || fail "Missing redline-skills source directory: $SKILLS_SOURCE_B"
[[ -d "$HARNESSES_SOURCE" ]] || fail "Missing harnesses source directory: $HARNESSES_SOURCE"
[[ -f "$FUNCTIONAL_TEMPLATE_SOURCE" ]] || fail "Missing functional index template: $FUNCTIONAL_TEMPLATE_SOURCE"
[[ -f "$RULES_INDEX_TEMPLATE_SOURCE" ]] || fail "Missing rules index template: $RULES_INDEX_TEMPLATE_SOURCE"

for required_template in "${REQUIRED_TEMPLATES[@]}"; do
  [[ -f "$TEMPLATES_SOURCE/$required_template" ]] || fail "Missing required template: $TEMPLATES_SOURCE/$required_template"
done

for required_skill in "${REQUIRED_SKILLS[@]}"; do
  if [[ -d "$SKILLS_SOURCE_A/$required_skill" || -d "$SKILLS_SOURCE_B/$required_skill" ]]; then
    continue
  fi
  fail "Missing required skill: $required_skill"
done

REDLINE_DIR="$TARGET_DIR/.redline"
SYSTEM_DIR="$REDLINE_DIR/system"
SYSTEM_TEMPLATES_DIR="$SYSTEM_DIR/templates"
PROJECT_DIR="$REDLINE_DIR/project"
FUNCTIONAL_DIR="$PROJECT_DIR/functional-truth"
RULES_DIR="$PROJECT_DIR/rules"
SPECS_DIR="$PROJECT_DIR/specs"
FUNCTIONAL_INDEX_DEST="$FUNCTIONAL_DIR/functional.index.md"
RULES_INDEX_DEST="$RULES_DIR/rules.index.md"

copy_templates_missing_only() {
  local template dest
  shopt -s nullglob
  for template in "$TEMPLATES_SOURCE"/*.md; do
    dest="$SYSTEM_TEMPLATES_DIR/$(basename "$template")"
    if [[ ! -e "$dest" ]]; then
      cp "$template" "$dest"
      log "Copied template: $(basename "$template")"
    fi
  done
  shopt -u nullglob
}

copy_skills_to_dir() {
  local target_skills_dir update_mode source_dir skill_dir dest
  target_skills_dir="$1"
  update_mode="$2"

  mkdir -p "$target_skills_dir"

  for source_dir in "$SKILLS_SOURCE_A" "$SKILLS_SOURCE_B"; do
    shopt -s nullglob
    for skill_dir in "$source_dir"/*; do
      [[ -d "$skill_dir" ]] || continue
      dest="$target_skills_dir/$(basename "$skill_dir")"
      if [[ "$update_mode" -eq 1 ]]; then
        rm -rf "$dest"
        cp -R "$skill_dir" "$dest"
        log "Refreshed harness skill: $(basename "$skill_dir")"
      elif [[ ! -e "$dest" ]]; then
        cp -R "$skill_dir" "$dest"
        log "Copied harness skill: $(basename "$skill_dir")"
      fi
    done
    shopt -u nullglob
  done
}

copy_launchers_to_dir() {
  local source_dir target_dir update_mode launcher dest
  source_dir="$1"
  target_dir="$2"
  update_mode="$3"

  [[ -d "$source_dir" ]] || fail "Missing harness launcher source directory: $source_dir"
  mkdir -p "$target_dir"

  shopt -s nullglob
  for launcher in "$source_dir"/*.md; do
    dest="$target_dir/$(basename "$launcher")"
    if [[ "$update_mode" -eq 1 ]]; then
      cp "$launcher" "$dest"
      log "Refreshed harness launcher: $(basename "$launcher")"
    elif [[ ! -e "$dest" ]]; then
      cp "$launcher" "$dest"
      log "Copied harness launcher: $(basename "$launcher")"
    fi
  done
  shopt -u nullglob
}

refresh_system() {
  rm -rf "$SYSTEM_TEMPLATES_DIR"
  mkdir -p "$SYSTEM_TEMPLATES_DIR"

  cp "$TEMPLATES_SOURCE"/*.md "$SYSTEM_TEMPLATES_DIR/"
  log "Refreshed system templates"
}

harness_is_installed() {
  local harness manifest HARNESS_ID HARNESS_SKILLS_PATH HARNESS_LAUNCHERS_PATH HARNESS_LAUNCHERS_SOURCE
  harness="$1"
  manifest="$HARNESSES_SOURCE/$harness/manifest.sh"

  [[ -f "$manifest" ]] || fail "Missing harness manifest: $manifest"

  HARNESS_ID=""
  HARNESS_SKILLS_PATH=""
  HARNESS_LAUNCHERS_PATH=""
  HARNESS_LAUNCHERS_SOURCE=""
  # shellcheck source=/dev/null
  source "$manifest"

  [[ "$HARNESS_ID" == "$harness" ]] || fail "Harness manifest id mismatch for $harness"
  [[ -n "$HARNESS_SKILLS_PATH" ]] || fail "Harness $harness does not define HARNESS_SKILLS_PATH"
  [[ -n "$HARNESS_LAUNCHERS_PATH" ]] || fail "Harness $harness does not define HARNESS_LAUNCHERS_PATH"

  [[ -e "$TARGET_DIR/$HARNESS_SKILLS_PATH" || -e "$TARGET_DIR/$HARNESS_LAUNCHERS_PATH" ]]
}

detect_installed_harnesses() {
  local harness
  for harness in $SUPPORTED_HARNESSES; do
    if harness_is_installed "$harness"; then
      add_harness "$harness"
      log "Detected installed harness: $harness"
    fi
  done
}

install_harness() {
  local harness manifest HARNESS_ID HARNESS_SKILLS_PATH HARNESS_LAUNCHERS_PATH HARNESS_LAUNCHERS_SOURCE
  local target_skills_dir target_launchers_dir launchers_source_dir
  harness="$1"
  manifest="$HARNESSES_SOURCE/$harness/manifest.sh"

  [[ -f "$manifest" ]] || fail "Missing harness manifest: $manifest"

  HARNESS_ID=""
  HARNESS_SKILLS_PATH=""
  HARNESS_LAUNCHERS_PATH=""
  HARNESS_LAUNCHERS_SOURCE=""
  # shellcheck source=/dev/null
  source "$manifest"

  [[ "$HARNESS_ID" == "$harness" ]] || fail "Harness manifest id mismatch for $harness"
  [[ -n "$HARNESS_SKILLS_PATH" ]] || fail "Harness $harness does not define HARNESS_SKILLS_PATH"
  [[ -n "$HARNESS_LAUNCHERS_PATH" ]] || fail "Harness $harness does not define HARNESS_LAUNCHERS_PATH"
  [[ -n "$HARNESS_LAUNCHERS_SOURCE" ]] || fail "Harness $harness does not define HARNESS_LAUNCHERS_SOURCE"

  target_skills_dir="$TARGET_DIR/$HARNESS_SKILLS_PATH"
  target_launchers_dir="$TARGET_DIR/$HARNESS_LAUNCHERS_PATH"
  launchers_source_dir="$HARNESSES_SOURCE/$harness/$HARNESS_LAUNCHERS_SOURCE"

  log "Installing harness bindings: $harness"
  copy_skills_to_dir "$target_skills_dir" "$UPDATE_HARNESS"
  copy_launchers_to_dir "$launchers_source_dir" "$target_launchers_dir" "$UPDATE_HARNESS"
}

bootstrap_project_files() {
  if [[ ! -e "$FUNCTIONAL_INDEX_DEST" ]]; then
    cp "$FUNCTIONAL_TEMPLATE_SOURCE" "$FUNCTIONAL_INDEX_DEST"
    log "Bootstrapped project functional.index.md"
  else
    log "Kept existing project functional.index.md"
  fi

  if [[ ! -e "$RULES_INDEX_DEST" ]]; then
    cp "$RULES_INDEX_TEMPLATE_SOURCE" "$RULES_INDEX_DEST"
    log "Bootstrapped project rules.index.md"
  else
    log "Kept existing project rules.index.md"
  fi
}

log "Installing RedlineSpec into: $TARGET_DIR"

if [[ -z "$SELECTED_HARNESSES" ]]; then
  if [[ "$UPDATE_HARNESS" -eq 1 ]]; then
    detect_installed_harnesses
    if [[ -z "$SELECTED_HARNESSES" ]]; then
      fail "No installed harness bindings detected. Pass --harness opencode or --harness windsurf to install one."
    fi
  elif [[ "$UPDATE_SYSTEM" -eq 1 ]]; then
    :
  else
    prompt_for_harness
  fi
fi

mkdir -p "$SYSTEM_TEMPLATES_DIR" "$FUNCTIONAL_DIR" "$RULES_DIR" "$SPECS_DIR"

if [[ "$UPDATE_SYSTEM" -eq 1 ]]; then
  refresh_system
else
  copy_templates_missing_only
fi

bootstrap_project_files

for harness in $SELECTED_HARNESSES; do
  install_harness "$harness"
done

log "Done. Canonical layout available under $REDLINE_DIR"
