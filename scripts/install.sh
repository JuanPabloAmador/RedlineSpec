#!/usr/bin/env bash
set -euo pipefail

print_help() {
  cat <<'EOF'
RedlineSpec installer

Usage:
  bash scripts/install.sh TARGET_PATH [--update] [--update-system] [--harness devin[,codex,opencode,pi,claude]]... [--update-harness]

Behavior:
  - TARGET_PATH is required and must point to the destination project repository.
  - This RedlineSpec repository is the source of the installer assets and should stay separate from the destination repository.
  - Creates the canonical .redline/ layout inside the target repository.
  - Copies distributed templates into .redline/system/templates/.
  - Copies deterministic framework scripts into .redline/system/scripts/.
  - Requires a harness selection for installs, either through --harness or an interactive terminal prompt.
  - In --update mode, detects already installed harness bindings automatically.
  - Copies Agent Skills only into effective harness-visible skill directories for the selected harnesses.
  - Deduplicates the shared .agents/skills/ destination across compatible harnesses.
  - Removes known deprecated RedlineSpec skills and old RedlineSpec launcher files from selected or detected harness bindings.
  - Bootstraps .redline/project/functional-truth/functional.index.md from the canonical template if missing.
  - Bootstraps .redline/project/rules/rules.index.md from the canonical template if missing.
  - Does not create any spec/plan/tasks change artifacts.

Options:
  --update          Refresh .redline/system/templates/ and all detected installed harness bindings.
                    Does not install new harnesses.
  --update-system   Refresh .redline/system/templates/ and .redline/system/scripts/ from this RedlineSpec repo.
                    This may overwrite existing framework-managed files under .redline/system/.
  --harness NAME    Install harness bindings. Supported values: devin, codex, claude, opencode, pi.
                    May be repeated or passed as a comma-separated list.
                    Harnesses in the shared .agents group install one copy to .agents/skills/.
                    Harnesses with private paths install to their own skills directory.
                    If omitted in an interactive terminal, the installer prompts for a harness.
                    If omitted in a non-interactive shell, installation fails.
  --update-harness  Refresh RedlineSpec-managed harness skills and remove known deprecated RedlineSpec skills and launcher files.
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
SUPPORTED_HARNESSES="devin codex claude opencode pi"

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
    fail "Harness selection is required. Pass --harness devin, --harness opencode, --harness pi, or repeat --harness for multiple harnesses."
  fi

  printf '\nSelect RedlineSpec harness bindings to install. Use comma-separated numbers for multiple choices.\n'
  printf '  1) devin (.agents/skills)\n'
  printf '  2) codex (.agents/skills)\n'
  printf '  3) opencode (.agents/skills)\n'
  printf '  4) pi (.agents/skills)\n'
  printf '  5) claude (.claude/skills)\n'

  while true; do
    printf 'Harnesses [1,4,5]: '
    read -r choice
    selected_count="$(harness_count)"
    selected_before="$SELECTED_HARNESSES"
    choice="${choice//,/ }"
    for item in $choice; do
      case "$item" in
        1|devin)
          add_harness devin
          ;;
        2|codex)
          add_harness codex
          ;;
        3|opencode)
          add_harness opencode
          ;;
        4|pi)
          add_harness pi
          ;;
        5|claude)
          add_harness claude
          ;;
        *)
          printf 'Invalid selection: %s. Choose 1, 2, 3, 4, 5, or multiple values like 1,4.\n' "$item" >&2
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
        fail "--harness requires a value: devin, codex, claude, opencode, or pi. Repeat the flag or use commas for multiple harnesses."
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
HEALTH_CHECK_SCRIPT_SOURCE="$REPO_ROOT/scripts/health-check.sh"
REQUIRED_TEMPLATES=(
  spec.template.md
  plan.template.md
  plan-technical-unit.template.md
  tasks.template.md
  task.template.md
  functional.index.template.md
  functional.entry.template.md
  functional.global.entry.template.md
  rules.index.template.md
  rule.template.md
)
REQUIRED_SKILLS=(
  redlinespec
  interview
  write-spec
  write-plan
  write-tasks
  write-rules
  implement
  bootstrap-functional-truth
  close-spec
  merge-functional-truth
  health-check
)
DEPRECATED_SKILLS=(
  redlinespec-spec-authoring
)

[[ -d "$TEMPLATES_SOURCE" ]] || fail "Missing templates source directory: $TEMPLATES_SOURCE"
[[ -d "$SKILLS_SOURCE_A" ]] || fail "Missing skills source directory: $SKILLS_SOURCE_A"
[[ -d "$SKILLS_SOURCE_B" ]] || fail "Missing redline-skills source directory: $SKILLS_SOURCE_B"
[[ -d "$HARNESSES_SOURCE" ]] || fail "Missing harnesses source directory: $HARNESSES_SOURCE"
[[ -f "$FUNCTIONAL_TEMPLATE_SOURCE" ]] || fail "Missing functional index template: $FUNCTIONAL_TEMPLATE_SOURCE"
[[ -f "$RULES_INDEX_TEMPLATE_SOURCE" ]] || fail "Missing rules index template: $RULES_INDEX_TEMPLATE_SOURCE"
[[ -f "$HEALTH_CHECK_SCRIPT_SOURCE" ]] || fail "Missing health check script: $HEALTH_CHECK_SCRIPT_SOURCE"

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
SYSTEM_SCRIPTS_DIR="$SYSTEM_DIR/scripts"
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

copy_system_scripts_missing_only() {
  local dest
  mkdir -p "$SYSTEM_SCRIPTS_DIR"
  dest="$SYSTEM_SCRIPTS_DIR/health-check.sh"
  if [[ ! -e "$dest" ]]; then
    cp "$HEALTH_CHECK_SCRIPT_SOURCE" "$dest"
    chmod +x "$dest"
    log "Copied system script: health-check.sh"
  fi
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

remove_deprecated_skills_from_dir() {
  local target_skills_dir deprecated_skill deprecated_path
  target_skills_dir="$1"

  for deprecated_skill in "${DEPRECATED_SKILLS[@]}"; do
    deprecated_path="$target_skills_dir/$deprecated_skill"
    if [[ -e "$deprecated_path" ]]; then
      rm -rf "$deprecated_path"
      log "Removed deprecated harness skill: $deprecated_skill"
    fi
  done
}

# Temporary migration cleanup. See docs/en/deprecations.md before removing or extending.
remove_deprecated_launchers_for_harness() {
  local harness launcher launcher_path launcher_dir
  harness="$1"

  case "$harness" in
    opencode)
      launcher_dir="$TARGET_DIR/.opencode/commands"
      ;;
    *)
      return 0
      ;;
  esac

  [[ -d "$launcher_dir" ]] || return 0

  for launcher in "${REQUIRED_SKILLS[@]}"; do
    launcher_path="$launcher_dir/$launcher.md"
    if [[ -e "$launcher_path" ]]; then
      rm -f "$launcher_path"
      log "Removed deprecated harness launcher: $launcher_path"
    fi
  done
}

refresh_system() {
  rm -rf "$SYSTEM_TEMPLATES_DIR" "$SYSTEM_SCRIPTS_DIR"
  mkdir -p "$SYSTEM_TEMPLATES_DIR" "$SYSTEM_SCRIPTS_DIR"

  cp "$TEMPLATES_SOURCE"/*.md "$SYSTEM_TEMPLATES_DIR/"
  cp "$HEALTH_CHECK_SCRIPT_SOURCE" "$SYSTEM_SCRIPTS_DIR/health-check.sh"
  chmod +x "$SYSTEM_SCRIPTS_DIR/health-check.sh"
  log "Refreshed system templates"
  log "Refreshed system scripts"
}

load_harness_manifest() {
  local harness manifest
  harness="$1"
  manifest="$HARNESSES_SOURCE/$harness/manifest.sh"

  [[ -f "$manifest" ]] || fail "Missing harness manifest: $manifest"

  HARNESS_ID=""
  HARNESS_SKILLS_GROUP=""
  HARNESS_SKILLS_PATH=""
  # shellcheck source=/dev/null
  source "$manifest"

  [[ "$HARNESS_ID" == "$harness" ]] || fail "Harness manifest id mismatch for $harness"
  [[ -n "$HARNESS_SKILLS_PATH" ]] || fail "Harness $harness does not define HARNESS_SKILLS_PATH"
}

harness_is_installed() {
  local harness
  harness="$1"

  load_harness_manifest "$harness"
  [[ -e "$TARGET_DIR/$HARNESS_SKILLS_PATH" ]]
}

detect_installed_harnesses() {
  local harness seen_paths detected_path
  seen_paths=""
  for harness in $SUPPORTED_HARNESSES; do
    if harness_is_installed "$harness"; then
      detected_path="$HARNESS_SKILLS_PATH"
      add_harness "$harness"
      if [[ " $seen_paths " != *" $detected_path "* ]]; then
        seen_paths="$seen_paths $detected_path"
        log "Detected installed harness skills path: $detected_path"
      fi
    fi
  done
}

INSTALLED_HARNESS_SKILLS_PATHS=""

install_harness() {
  local harness target_skills_dir display
  harness="$1"

  load_harness_manifest "$harness"

  if [[ " $INSTALLED_HARNESS_SKILLS_PATHS " == *" $HARNESS_SKILLS_PATH "* ]]; then
    log "Skipping duplicate harness skills destination for $harness: $HARNESS_SKILLS_PATH"
    remove_deprecated_launchers_for_harness "$harness"
    return 0
  fi
  INSTALLED_HARNESS_SKILLS_PATHS="$INSTALLED_HARNESS_SKILLS_PATHS $HARNESS_SKILLS_PATH"

  target_skills_dir="$TARGET_DIR/$HARNESS_SKILLS_PATH"
  display="$harness"
  if [[ -n "$HARNESS_SKILLS_GROUP" ]]; then
    display="$display (group: $HARNESS_SKILLS_GROUP)"
  fi

  log "Installing harness bindings: $display -> $HARNESS_SKILLS_PATH"
  remove_deprecated_skills_from_dir "$target_skills_dir"
  copy_skills_to_dir "$target_skills_dir" "$UPDATE_HARNESS"
  remove_deprecated_launchers_for_harness "$harness"
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
      fail "No installed harness bindings detected. Pass --harness devin, --harness opencode, or --harness pi to install one."
    fi
  elif [[ "$UPDATE_SYSTEM" -eq 1 ]]; then
    :
  else
    prompt_for_harness
  fi
fi

mkdir -p "$SYSTEM_TEMPLATES_DIR" "$SYSTEM_SCRIPTS_DIR" "$FUNCTIONAL_DIR" "$RULES_DIR" "$SPECS_DIR"

if [[ "$UPDATE_SYSTEM" -eq 1 ]]; then
  refresh_system
else
  copy_templates_missing_only
  copy_system_scripts_missing_only
fi

bootstrap_project_files

for harness in $SELECTED_HARNESSES; do
  install_harness "$harness"
done

log "Done. Canonical layout available under $REDLINE_DIR"
