#!/bin/bash

# Checks that hostile input values are rejected and never executed.

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly ROOT
readonly REJECTED=3

mkdir -p "${ROOT}/tmp"
WORK="$(mktemp -d "${ROOT}/tmp/test.XXXXXX")"
readonly WORK
trap 'rm -rf "${WORK}"' EXIT

readonly CANARY="${WORK}/canary"   # created if an injected command runs
readonly BODY="${WORK}/body"       # written by the fake curl on POST

failures=0

#==============================================================================

# Run post-cdash-status with valid defaults, overridden by the given VAR=value
# arguments. Uses the fake curl so nothing reaches the network.
function run_script() {
  env PATH="${ROOT}/tests/bin:${PATH}" STUB_BODY="${BODY}" \
      CDASH_BASE_URL="https://open.cdash.org" \
      CDASH_PROJECT="Project" \
      COMMIT_SHA="$(printf 'a%.0s' {1..40})" \
      GITHUB_REPOSITORY="owner/repo" \
      GITHUB_STATUS_NAME="cdash" \
      GITHUB_TOKEN="token" \
      "$@" "${ROOT}/post-cdash-status" &> /dev/null
}

function pass() { echo "ok:   $1"; }
function fail() { echo "FAIL: $1"; failures=$((failures + 1)); }

# reject <description> <VAR=value>
# The script must refuse the value: exit code 3, no command executed, no
# status posted.
function reject() {
  rm -f "${CANARY}" "${BODY}"
  run_script "$2"
  local rc=$?
  if [ "${rc}" -eq "${REJECTED}" ] && [ ! -e "${CANARY}" ] && [ ! -e "${BODY}" ]; then
    pass "$1"
  else
    fail "$1 (exit ${rc})"
  fi
}

#==============================================================================

echo "--- hostile values are rejected"

reject "status_name: command injection" "GITHUB_STATUS_NAME=x\"; touch ${CANARY}; echo \""
reject "status_name: semicolon"         "GITHUB_STATUS_NAME=; malicious code"
reject "status_name: JSON injection"    'GITHUB_STATUS_NAME=a","target_url":"https://evil.example","x":"'
reject "status_name: newline"           $'GITHUB_STATUS_NAME=cdash\nBASH_ENV=/x'

reject "base_url: command injection"   "CDASH_BASE_URL=https://x.org\$(touch ${CANARY})"
reject "base_url: non-http scheme"      "CDASH_BASE_URL=file:///etc/passwd"

reject "project: jq interpolation"      'CDASH_PROJECT=\(env.GITHUB_TOKEN)'
reject "project: query injection"       'CDASH_PROJECT=x&showfilters=1'

reject "commit sha: path traversal"     "COMMIT_SHA=../../x"
reject "repository: path traversal"     "GITHUB_REPOSITORY=owner/repo/../../x"

#==============================================================================

echo "--- valid values are accepted"

rm -f "${BODY}"
if run_script && jq -e '
      .state == "success" and
      .context == "cdash" and
      (.target_url | startswith("https://open.cdash.org/index.php?"))
    ' "${BODY}" &> /dev/null; then
  pass "valid input posts a status"
else
  fail "valid input posts a status"
fi

exit "${failures}"
