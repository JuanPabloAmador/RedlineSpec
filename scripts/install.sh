#!/usr/bin/env bash
set -euo pipefail

print_help() {
  cat <<'EOF'
RedlineSpec installer

Usage:
  bash scripts/install.sh TARGET_PATH [--update-system]

Behavior:
  - TARGET_PATH is required and must point to the destination project repository.
  - This RedlineSpec repository is the source of the installer assets and should stay separate from the destination repository.
  - Creates the canonical .redline/ layout inside the target repository.
  - Copies distributed templates and skills into .redline/system/.
  - Bootstraps .redline/project/functional-truth/functional.index.md from the canonical template if missing.
  - Bootstraps .redline/project/rules/rules.index.md from the canonical template if missing.
  - Does not create any spec/plan/tasks change artifacts.

Options:
  --update-system   Refresh .redline/system/templates/ and .redline/system/skills/ from this RedlineSpec repo.
                    This may overwrite existing framework-managed files under .redline/system/.
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
TARGET_PATH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --update-system)
      UPDATE_SYSTEM=1
      shift
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
SYSTEM_SKILLS_DIR="$SYSTEM_DIR/skills"
PROJECT_DIR="$REDLINE_DIR/project"
FUNCTIONAL_DIR="$PROJECT_DIR/functional-truth"
RULES_DIR="$PROJECT_DIR/rules"
SPECS_DIR="$PROJECT_DIR/specs"
FUNCTIONAL_INDEX_DEST="$FUNCTIONAL_DIR/functional.index.md"
RULES_INDEX_DEST="$RULES_DIR/rules.index.md"

mkdir -p "$SYSTEM_TEMPLATES_DIR" "$SYSTEM_SKILLS_DIR" "$FUNCTIONAL_DIR" "$RULES_DIR" "$SPECS_DIR"

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

copy_skills_missing_only() {
  local skill_dir dest
  for source_dir in "$SKILLS_SOURCE_A" "$SKILLS_SOURCE_B"; do
    shopt -s nullglob
    for skill_dir in "$source_dir"/*; do
      [[ -d "$skill_dir" ]] || continue
      dest="$SYSTEM_SKILLS_DIR/$(basename "$skill_dir")"
      if [[ ! -e "$dest" ]]; then
        cp -R "$skill_dir" "$dest"
        log "Copied skill: $(basename "$skill_dir")"
      fi
    done
    shopt -u nullglob
  done
}

refresh_system() {
  rm -rf "$SYSTEM_TEMPLATES_DIR" "$SYSTEM_SKILLS_DIR"
  mkdir -p "$SYSTEM_TEMPLATES_DIR" "$SYSTEM_SKILLS_DIR"

  cp "$TEMPLATES_SOURCE"/*.md "$SYSTEM_TEMPLATES_DIR/"
  log "Refreshed system templates"

  local skill_dir
  for source_dir in "$SKILLS_SOURCE_A" "$SKILLS_SOURCE_B"; do
    shopt -s nullglob
    for skill_dir in "$source_dir"/*; do
      [[ -d "$skill_dir" ]] || continue
      cp -R "$skill_dir" "$SYSTEM_SKILLS_DIR/$(basename "$skill_dir")"
      log "Refreshed skill: $(basename "$skill_dir")"
    done
    shopt -u nullglob
  done
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

if [[ "$UPDATE_SYSTEM" -eq 1 ]]; then
  refresh_system
else
  copy_templates_missing_only
  copy_skills_missing_only
fi

bootstrap_project_files

log "Done. Canonical layout available under $REDLINE_DIR"
