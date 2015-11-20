#!/usr/bin/env bash
#
#
# Authors:
#   rfsfrn <rfsfrn@users.noreply.github.com>

flunk() {
  {
    if [ "$#" -eq 0 ]; then
      cat -
    else
      echo -n -e "$@"
    fi
  } >&2
  return 1
}

assert() {
  if ! "$@"; then
    flunk "failed: $@"
  fi
}

assert_equal() {
  if [ "$1" != "$2" ]; then
    {
      echo "expected: $1"
      echo "actual:   $2"
    } | flunk
  fi
}

refute_line() {
  if [ "$1" -ge 0 ] 2>/dev/null; then
    local num_lines="${#lines[@]}"
    if [ "$1" -lt "$num_lines" ]; then
      flunk "output has $num_lines lines"
    fi
  else
    local line
    for line in "${lines[@]}"; do
      if [ "$line" = "$1" ]; then
        flunk "expected to not find line \`$line'"
      fi
    done
  fi
}

assert_line() {
  if [ "$1" -ge 0 ] 2>/dev/null; then
    assert_equal "$2" "${lines[$1]}"
  else
    local line
    for line in "${lines[@]}"; do
      if [ "$line" = "$1" ]; then
        return 0
      fi
    done
    flunk "expected line \`$1'"
  fi
}

assert_output() {
  local expected
  if [ $# -eq 0 ]; then
    expected="$(cat -)"
  else
    expected="$1"
  fi
  assert_equal "$expected" "$output"
}

assert_status() {
  assert_equal "$1" "$status"
}

assert_success() {
  if [ "$status" -ne 0 ]; then
   flunk "command failed with exit status ${status}\\noutput: ${output}"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_failure() {
  if [ "$status" -ne 1 ]; then
    flunk $(printf "expected failed exit status=1, got status=%d" $status)
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_match() {
  out="${2:-${output}}"
  if [ ! $(echo "${out}" | grep -- "${1}") ]; then
    {
      echo "expected match: $1"
      echo "actual: $out"
    } | flunk
  fi
}
