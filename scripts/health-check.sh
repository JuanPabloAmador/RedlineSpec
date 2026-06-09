#!/usr/bin/env bash
set -euo pipefail

print_help() {
  cat <<'EOF'
RedlineSpec health check

Usage:
  bash scripts/health-check.sh TARGET_PATH [--json]

Checks deterministic RedlineSpec installation and documentation structure facts.
Semantic quality is reviewed by the /health-check skill using this script output.
EOF
}

JSON=0
TARGET_PATH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --json)
      JSON=1
      shift
      ;;
    -h|--help)
      print_help
      exit 0
      ;;
    *)
      if [[ -n "$TARGET_PATH" ]]; then
        printf 'ERROR: Only one target path may be provided.\n' >&2
        exit 1
      fi
      TARGET_PATH="$1"
      shift
      ;;
  esac
done

if [[ -z "$TARGET_PATH" ]]; then
  print_help
  printf 'ERROR: TARGET_PATH is required.\n' >&2
  exit 1
fi

if [[ ! -d "$TARGET_PATH" ]]; then
  printf 'ERROR: Target path does not exist or is not a directory: %s\n' "$TARGET_PATH" >&2
  exit 1
fi

TARGET_DIR="$(cd "$TARGET_PATH" && pwd)"

REQUIRED_DIRS=(
  ".redline/system/templates"
  ".redline/system/scripts"
  ".redline/project/functional-truth"
  ".redline/project/rules"
  ".redline/project/specs"
)

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
  redlinespec-spec-authoring
  write-plan
  write-tasks
  write-rules
  implement
  bootstrap-functional-truth
  close-spec
  merge-functional-truth
  health-check
)

REQUIRED_LAUNCHERS=(
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

ISSUES=()
ERROR_COUNT=0
WARNING_COUNT=0
INFO_COUNT=0

json_escape() {
  local s
  s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  printf '%s' "$s"
}

add_issue() {
  local severity area location problem suggested deterministic id
  severity="$1"
  area="$2"
  location="$3"
  problem="$4"
  suggested="$5"
  deterministic="true"

  case "$severity" in
    error) ERROR_COUNT=$((ERROR_COUNT + 1)) ;;
    warning) WARNING_COUNT=$((WARNING_COUNT + 1)) ;;
    info) INFO_COUNT=$((INFO_COUNT + 1)) ;;
  esac

  id="RLS-HC-$(printf '%03d' $((${#ISSUES[@]} + 1)))"
  ISSUES+=("$id|$severity|$area|$location|$problem|$suggested|$deterministic")
}

file_has_heading() {
  local file heading
  file="$1"
  heading="$2"
  grep -Eq "^#{1,6}[[:space:]]+$heading[[:space:]]*$" "$file"
}

extract_md_links() {
  local file
  file="$1"
  grep -Eo '\[[^]]+\]\([^)]+\)' "$file" 2>/dev/null \
    | sed -E 's/^.*\(([^)#?]+).*$/\1/' \
    | grep -E '\.md$' || true
}

check_required_dirs() {
  local dir
  for dir in "${REQUIRED_DIRS[@]}"; do
    if [[ ! -d "$TARGET_DIR/$dir" ]]; then
      add_issue error installation "$dir" "Missing required RedlineSpec directory." "Run scripts/install.sh for this target or restore the directory."
    fi
  done
}

check_system_scripts() {
  local script
  script="$TARGET_DIR/.redline/system/scripts/health-check.sh"
  if [[ ! -f "$script" ]]; then
    add_issue error installation ".redline/system/scripts/health-check.sh" "Missing installed deterministic health-check script." "Refresh system assets with scripts/install.sh TARGET --update-system."
  elif [[ ! -x "$script" ]]; then
    add_issue warning installation ".redline/system/scripts/health-check.sh" "Installed health-check script is not executable." "Run chmod +x .redline/system/scripts/health-check.sh or refresh system assets."
  fi
}

check_templates() {
  local template
  for template in "${REQUIRED_TEMPLATES[@]}"; do
    if [[ ! -f "$TARGET_DIR/.redline/system/templates/$template" ]]; then
      add_issue error installation ".redline/system/templates/$template" "Missing required system template." "Refresh system templates with scripts/install.sh TARGET --update-system."
    fi
  done
}

check_functional_truth() {
  local dir index link target file rel seen
  dir="$TARGET_DIR/.redline/project/functional-truth"
  index="$dir/functional.index.md"

  [[ -d "$dir" ]] || return 0

  if [[ ! -f "$index" ]]; then
    add_issue error functional-truth ".redline/project/functional-truth/functional.index.md" "Missing functional truth index." "Create it from functional.index.template.md or rerun installer bootstrap."
    return 0
  fi

  for heading in "Purpose" "Coverage Status" "System Overview" "Functional Areas"; do
    if ! file_has_heading "$index" "$heading"; then
      add_issue warning functional-truth ".redline/project/functional-truth/functional.index.md" "Functional truth index is missing expected heading: $heading." "Review the file against functional.index.template.md."
    fi
  done

  seen=""
  while IFS= read -r link; do
    [[ -n "$link" ]] || continue
    [[ "$link" == http://* || "$link" == https://* ]] && continue
    [[ " $seen " == *" $link "* ]] && continue
    seen="$seen $link"
    if [[ "$link" == *"{{"* || "$link" == *"}}"* ]]; then
      add_issue warning functional-truth ".redline/project/functional-truth/functional.index.md" "Functional truth index still contains template placeholder link: $link." "Replace template placeholders with real entries or remove them during bootstrap."
      continue
    fi
    target="$dir/$link"
    if [[ "$link" != *.entry.md && "$link" != *.global.entry.md ]]; then
      add_issue warning functional-truth ".redline/project/functional-truth/functional.index.md" "Index links to a markdown file that is not a functional truth entry: $link." "Keep functional truth links pointed at *.entry.md or *.global.entry.md files."
    fi
    if [[ ! -f "$target" ]]; then
      add_issue error functional-truth ".redline/project/functional-truth/functional.index.md" "Index links to missing file: $link." "Create the missing entry or remove the link."
    fi
  done < <(extract_md_links "$index")

  while IFS= read -r file; do
    rel="$(basename "$file")"
    [[ "$rel" == "functional.index.md" ]] && continue
    if [[ "$rel" != *.entry.md && "$rel" != *.global.entry.md ]]; then
      add_issue warning functional-truth ".redline/project/functional-truth/$rel" "Unexpected markdown file in functional truth directory." "Move temporary or unrelated documentation out of functional-truth/."
      continue
    fi
    if [[ " $seen " != *" $rel "* ]]; then
      add_issue warning functional-truth ".redline/project/functional-truth/$rel" "Functional truth entry exists but is not linked from functional.index.md." "Add the entry to the index or remove it if stale."
    fi
  done < <(find "$dir" -maxdepth 1 -type f -name '*.md' | sort)
}

check_rules() {
  local dir index link target file rel seen
  dir="$TARGET_DIR/.redline/project/rules"
  index="$dir/rules.index.md"

  [[ -d "$dir" ]] || return 0

  if [[ ! -f "$index" ]]; then
    add_issue error rules ".redline/project/rules/rules.index.md" "Missing project rules index." "Create it from rules.index.template.md or rerun installer bootstrap."
    return 0
  fi

  seen=""
  while IFS= read -r link; do
    [[ -n "$link" ]] || continue
    [[ "$link" == http://* || "$link" == https://* ]] && continue
    [[ " $seen " == *" $link "* ]] && continue
    seen="$seen $link"
    if [[ "$link" == *"{{"* || "$link" == *"}}"* || "$link" == *"-example.rule.md" ]]; then
      add_issue warning rules ".redline/project/rules/rules.index.md" "Rules index still contains template/example link: $link." "Replace examples with real rules or remove them during rules bootstrap."
      continue
    fi
    target="$dir/$link"
    if [[ "$link" != *.rule.md ]]; then
      add_issue warning rules ".redline/project/rules/rules.index.md" "Rules index links to a markdown file that is not a rule: $link." "Keep rules index links pointed at *.rule.md files."
    fi
    if [[ ! -f "$target" ]]; then
      add_issue error rules ".redline/project/rules/rules.index.md" "Rules index links to missing file: $link." "Create the missing rule or remove the link."
    fi
  done < <(extract_md_links "$index")

  while IFS= read -r file; do
    rel="$(basename "$file")"
    [[ "$rel" == "rules.index.md" ]] && continue
    if [[ "$rel" != *.rule.md ]]; then
      add_issue warning rules ".redline/project/rules/$rel" "Unexpected markdown file in rules directory." "Move unrelated documentation out of rules/."
      continue
    fi
    if [[ " $seen " != *" $rel "* ]]; then
      add_issue warning rules ".redline/project/rules/$rel" "Rule file exists but is not linked from rules.index.md." "Add the rule to the index or remove it if stale."
    fi
  done < <(find "$dir" -maxdepth 1 -type f -name '*.md' | sort)
}

check_specs() {
  local specs dir name spec
  specs="$TARGET_DIR/.redline/project/specs"
  [[ -d "$specs" ]] || return 0

  while IFS= read -r dir; do
    name="$(basename "$dir")"
    spec="$dir/$name.spec.md"
    if [[ ! -f "$spec" ]]; then
      add_issue error specs ".redline/project/specs/$name" "Spec directory is missing its canonical spec file: $name.spec.md." "Create or restore the spec file, or remove the stale spec directory."
    fi
    if [[ -d "$dir/tasks" && ! -d "$dir/plan" ]]; then
      add_issue warning specs ".redline/project/specs/$name/tasks" "Tasks directory exists without a sibling plan directory." "Create the plan contract or remove stale tasks."
    fi
  done < <(find "$specs" -mindepth 1 -maxdepth 1 -type d | sort)
}

check_harnesses() {
  local harness skill launcher skill_dir launcher_dir

  if [[ -d "$TARGET_DIR/.opencode/skills" ]]; then
    skill_dir="$TARGET_DIR/.opencode/skills"
    launcher_dir="$TARGET_DIR/.opencode/commands"
    for skill in "${REQUIRED_SKILLS[@]}"; do
      [[ -f "$skill_dir/$skill/SKILL.md" ]] || add_issue error harness ".opencode/skills/$skill/SKILL.md" "Missing OpenCode RedlineSpec skill." "Refresh harness bindings with scripts/install.sh TARGET --update-harness --harness opencode."
    done
    for launcher in "${REQUIRED_LAUNCHERS[@]}"; do
      [[ -f "$launcher_dir/$launcher.md" ]] || add_issue error harness ".opencode/commands/$launcher.md" "Missing OpenCode RedlineSpec command launcher." "Refresh harness bindings with scripts/install.sh TARGET --update-harness --harness opencode."
    done
  fi

  if [[ -d "$TARGET_DIR/.windsurf/skills" ]]; then
    skill_dir="$TARGET_DIR/.windsurf/skills"
    launcher_dir="$TARGET_DIR/.windsurf/workflows"
    for skill in "${REQUIRED_SKILLS[@]}"; do
      [[ -f "$skill_dir/$skill/SKILL.md" ]] || add_issue error harness ".windsurf/skills/$skill/SKILL.md" "Missing Windsurf RedlineSpec skill." "Refresh harness bindings with scripts/install.sh TARGET --update-harness --harness windsurf."
    done
    for launcher in "${REQUIRED_LAUNCHERS[@]}"; do
      [[ -f "$launcher_dir/$launcher.md" ]] || add_issue error harness ".windsurf/workflows/$launcher.md" "Missing Windsurf RedlineSpec workflow launcher." "Refresh harness bindings with scripts/install.sh TARGET --update-harness --harness windsurf."
    done
  fi

  if [[ -d "$TARGET_DIR/.pi/skills" ]]; then
    skill_dir="$TARGET_DIR/.pi/skills"
    for skill in "${REQUIRED_SKILLS[@]}"; do
      [[ -f "$skill_dir/$skill/SKILL.md" ]] || add_issue error harness ".pi/skills/$skill/SKILL.md" "Missing Pi RedlineSpec skill." "Refresh harness bindings with scripts/install.sh TARGET --update-harness --harness pi."
    done
  fi
}

check_required_dirs
check_templates
check_system_scripts
check_functional_truth
check_rules
check_specs
check_harnesses

STATUS="pass"
if [[ "$ERROR_COUNT" -gt 0 ]]; then
  STATUS="fail"
elif [[ "$WARNING_COUNT" -gt 0 ]]; then
  STATUS="warning"
fi

if [[ "$JSON" -eq 1 ]]; then
  printf '{\n'
  printf '  "target": "%s",\n' "$(json_escape "$TARGET_DIR")"
  printf '  "status": "%s",\n' "$STATUS"
  printf '  "summary": {"errors": %d, "warnings": %d, "info": %d},\n' "$ERROR_COUNT" "$WARNING_COUNT" "$INFO_COUNT"
  printf '  "issues": [\n'
  for i in "${!ISSUES[@]}"; do
    IFS='|' read -r id severity area location problem suggested deterministic <<< "${ISSUES[$i]}"
    printf '    {"id": "%s", "severity": "%s", "area": "%s", "location": "%s", "problem": "%s", "suggested_fix": "%s", "deterministic": %s}' \
      "$(json_escape "$id")" "$(json_escape "$severity")" "$(json_escape "$area")" "$(json_escape "$location")" "$(json_escape "$problem")" "$(json_escape "$suggested")" "$deterministic"
    if [[ "$i" -lt $((${#ISSUES[@]} - 1)) ]]; then
      printf ','
    fi
    printf '\n'
  done
  printf '  ]\n'
  printf '}\n'
else
  printf 'RedlineSpec Health Check\n'
  printf 'Target: %s\n' "$TARGET_DIR"
  printf 'Status: %s\n' "$STATUS"
  printf 'Errors: %d  Warnings: %d  Info: %d\n\n' "$ERROR_COUNT" "$WARNING_COUNT" "$INFO_COUNT"
  if [[ "${#ISSUES[@]}" -eq 0 ]]; then
    printf 'No deterministic issues found.\n'
  else
    for issue in "${ISSUES[@]}"; do
      IFS='|' read -r id severity area location problem suggested deterministic <<< "$issue"
      printf '[%s] %s %s\n' "$severity" "$id" "$area"
      printf '  Location: %s\n' "$location"
      printf '  Problem: %s\n' "$problem"
      printf '  Suggested fix: %s\n\n' "$suggested"
    done
  fi
fi

if [[ "$ERROR_COUNT" -gt 0 ]]; then
  exit 1
fi
exit 0
