#!/usr/bin/env bash
set -euo pipefail

print_help() {
  cat <<'EOF'
RedlineSpec health check

Usage:
  bash scripts/health-check.sh TARGET_PATH [--json]

Checks deterministic RedlineSpec installation and documentation structure facts.
Semantic quality is reviewed by the health-check skill using this script output.
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

check_skill_frontmatter() {
  local file rel expected_name line line_no in_frontmatter description_mode name description seen_name seen_description top_key problem content
  file="$1"
  rel="$2"
  expected_name="$(basename "$(dirname "$file")")"
  line_no=0
  in_frontmatter=0
  description_mode=0
  name=""
  description=""
  seen_name=0
  seen_description=0
  problem=""

  while IFS= read -r line || [[ -n "$line" ]]; do
    line_no=$((line_no + 1))

    if [[ "$line_no" -eq 1 ]]; then
      if [[ "$line" != "---" ]]; then
        problem="Missing YAML frontmatter opening delimiter."
        break
      fi
      in_frontmatter=1
      continue
    fi

    if [[ "$in_frontmatter" -eq 1 && "$line" == "---" ]]; then
      in_frontmatter=0
      break
    fi

    if [[ "$in_frontmatter" -ne 1 ]]; then
      continue
    fi

    if [[ "$description_mode" -eq 1 ]]; then
      if [[ "$line" == "  "* || -z "$line" ]]; then
        content="${line#  }"
        description="$description $content"
        continue
      fi
      description_mode=0
    fi

    case "$line" in
      name:*)
        if [[ "$seen_name" -eq 1 ]]; then
          problem="Duplicate name field in skill frontmatter."
          break
        fi
        seen_name=1
        name="${line#name:}"
        name="${name# }"
        if [[ -z "$name" ]]; then
          problem="Skill name must be a non-empty scalar."
          break
        fi
        if [[ "$name" == /* ]]; then
          problem="Skill name must not start with /."
          break
        fi
        ;;
      "description: >-")
        if [[ "$seen_description" -eq 1 ]]; then
          problem="Duplicate description field in skill frontmatter."
          break
        fi
        seen_description=1
        description_mode=1
        ;;
      description:*)
        problem="Skill description must use YAML block scalar form: description: >-."
        break
        ;;
      *:*)
        top_key="${line%%:*}"
        problem="Unexpected frontmatter field: $top_key. Only name and description are allowed."
        break
        ;;
      "")
        ;;
      *)
        problem="Unsupported frontmatter line: $line"
        break
        ;;
    esac
  done < "$file"

  if [[ -z "$problem" && "$in_frontmatter" -eq 1 ]]; then
    problem="YAML frontmatter is not closed with --- delimiter."
  fi
  if [[ -z "$problem" && "$seen_name" -ne 1 ]]; then
    problem="Missing name field in skill frontmatter."
  fi
  if [[ -z "$problem" && "$seen_description" -ne 1 ]]; then
    problem="Missing description field in skill frontmatter."
  fi
  if [[ -z "$problem" && "$name" != "$expected_name" ]]; then
    problem="Skill name mismatch: expected \"$expected_name\" from folder name, got \"$name\"."
  fi
  if [[ -z "$problem" && -z "${description// /}" ]]; then
    problem="Skill description must be non-empty."
  fi
  if [[ -z "$problem" && "$description" == *"aliases:"* ]]; then
    problem="Skill description must not contain the YAML-hostile text aliases:."
  fi

  if [[ -n "$problem" ]]; then
    add_issue error harness "$rel" "$problem" "Update SKILL.md frontmatter to valid RedlineSpec Agent Skill YAML: name matching the skill folder plus description: >- only."
  fi
}

check_harness_skills_dir() {
  local rel_dir refresh_hint skill skill_file deprecated_skill
  rel_dir="$1"
  refresh_hint="$2"

  for skill in "${REQUIRED_SKILLS[@]}"; do
    skill_file="$TARGET_DIR/$rel_dir/$skill/SKILL.md"
    if [[ -f "$skill_file" ]]; then
      check_skill_frontmatter "$skill_file" "$rel_dir/$skill/SKILL.md"
    else
      add_issue error harness "$rel_dir/$skill/SKILL.md" "Missing RedlineSpec skill in installed harness skills directory." "$refresh_hint"
    fi
  done

  for deprecated_skill in redlinespec-spec-authoring; do
    if [[ -e "$TARGET_DIR/$rel_dir/$deprecated_skill" ]]; then
      add_issue warning harness "$rel_dir/$deprecated_skill" "Deprecated RedlineSpec skill is still installed." "$refresh_hint"
    fi
  done
}

check_harnesses() {
  local launcher_dir launcher

  if [[ -d "$TARGET_DIR/.agents/skills" ]]; then
    check_harness_skills_dir ".agents/skills" "Refresh shared Agent Skills with scripts/install.sh TARGET --update-harness --harness devin."
  fi

  if [[ -d "$TARGET_DIR/.opencode/skills" ]]; then
    add_issue warning harness ".opencode/skills" "Deprecated OpenCode-specific skill path is installed; OpenCode now uses shared .agents/skills/." "Migrate by running scripts/install.sh TARGET --update-harness --harness opencode, then remove .opencode/skills if no longer needed."
  fi

  # Temporary migration check. See docs/en/deprecations.md before removing or extending.
  launcher_dir="$TARGET_DIR/.opencode/commands"
  if [[ -d "$launcher_dir" ]]; then
    for launcher in "${REQUIRED_SKILLS[@]}"; do
      [[ ! -f "$launcher_dir/$launcher.md" ]] || add_issue warning harness ".opencode/commands/$launcher.md" "Deprecated RedlineSpec OpenCode command launcher is still installed." "Refresh harness bindings with scripts/install.sh TARGET --update-harness --harness opencode to remove old launchers."
    done
  fi

  if [[ -d "$TARGET_DIR/.devin/skills" ]]; then
    add_issue warning harness ".devin/skills" "Deprecated Devin-specific skill path is installed; Devin now uses shared .agents/skills/." "Migrate by running scripts/install.sh TARGET --update-harness --harness devin, then remove .devin/skills if no longer needed."
    check_harness_skills_dir ".devin/skills" "Migrate Devin skills to .agents/skills with scripts/install.sh TARGET --update-harness --harness devin."
  fi

  if [[ -d "$TARGET_DIR/.pi/skills" ]]; then
    add_issue warning harness ".pi/skills" "Deprecated Pi-specific skill path is installed; Pi now uses shared .agents/skills/." "Migrate by running scripts/install.sh TARGET --update-harness --harness pi, then remove .pi/skills if no longer needed."
  fi

  if [[ -d "$TARGET_DIR/.claude/skills" ]]; then
    check_harness_skills_dir ".claude/skills" "Refresh harness bindings with scripts/install.sh TARGET --update-harness --harness claude."
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
