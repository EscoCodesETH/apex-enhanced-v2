#!/usr/bin/env bash
# APEX quality gate — runs after every Edit/Write/MultiEdit.
# Fast, non-blocking checks (lint / type-check). On failure it prints guidance to
# stderr and exits 2, which surfaces the problem to Claude so it fixes before moving on.
#
# Design goals: fast (no full test suite here — that belongs on Stop/commit),
# safe (never errors just because a tool is missing), and quiet on success.

set -uo pipefail

# --- Read the edited file path from the hook's JSON stdin (best-effort) ---
payload="$(cat 2>/dev/null || true)"
file=""
if command -v python3 >/dev/null 2>&1; then
  file="$(printf '%s' "$payload" | python3 -c \
    'import sys,json;
try:
    d=json.load(sys.stdin); print(d.get("tool_input",{}).get("file_path",""))
except Exception:
    print("")' 2>/dev/null)"
fi

# Skip throwaway/discovery work — spikes and experiments are meant to be messy.
# (APEX discovery mode lives here; production quality gates don't apply.)
case "$file" in
  */spikes/*|spikes/*|*/experiments/*|experiments/*|*/prototype/*|*/prototypes/*|\
  */poc/*|*/scratch/*|*/sandbox/*|*/playground/*) exit 0 ;;
esac

# Only gate source files; skip docs/config noise.
case "$file" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.py|*.rs|*.go) ;;
  *) exit 0 ;;
esac

fail=0
report=""
note() { report="${report}$1"$'\n'; }

run_if_script() { # $1 = npm script name
  node -e "process.exit(require('./package.json').scripts?.['$1']?0:1)" 2>/dev/null
}

# --- JS/TS projects ---
if [ -f package.json ]; then
  if run_if_script type-check; then
    out="$(npm run -s type-check 2>&1)" || { fail=1; note "❌ type-check failed:"; note "$out"; }
  fi
  if [ $fail -eq 0 ] && run_if_script lint; then
    out="$(npm run -s lint 2>&1)" || { fail=1; note "❌ lint failed:"; note "$out"; }
  fi
fi

# --- Python projects ---
if [[ "$file" == *.py ]] && command -v ruff >/dev/null 2>&1; then
  out="$(ruff check "$file" 2>&1)" || { fail=1; note "❌ ruff failed on $file:"; note "$out"; }
fi

# --- Rust / Go (fast checks) ---
if [[ "$file" == *.rs ]] && [ -f Cargo.toml ] && command -v cargo >/dev/null 2>&1; then
  out="$(cargo check --quiet 2>&1)" || { fail=1; note "❌ cargo check failed:"; note "$out"; }
fi
if [[ "$file" == *.go ]] && command -v gofmt >/dev/null 2>&1; then
  out="$(gofmt -l "$file" 2>&1)"; [ -n "$out" ] && { fail=1; note "❌ gofmt: $file is not formatted (run gofmt -w)"; }
fi

if [ $fail -ne 0 ]; then
  {
    echo "APEX quality gate blocked: fix these before continuing."
    echo "$report" | head -60
  } >&2
  exit 2
fi

exit 0
