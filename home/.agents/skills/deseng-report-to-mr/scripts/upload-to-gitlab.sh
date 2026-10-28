#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'USAGE'
Usage: upload-to-gitlab.sh <file>... 

Upload files to the Stratus GitLab project (5762) and print one markdown link
per file, ready to paste into an MR description.

`glab api -F file=@...` does not send multipart uploads, and glab run outside a
gitlab.cfdata.org checkout defaults to gitlab.com. This script reads the glab
token for gitlab.cfdata.org and posts with curl instead.

Env: GITLAB_HOST (default gitlab.cfdata.org), GITLAB_PROJECT (default 5762).
USAGE
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" || $# -eq 0 ]]; then
  usage
  [[ $# -eq 0 ]] && exit 1 || exit 0
fi

host=${GITLAB_HOST:-gitlab.cfdata.org}
project=${GITLAB_PROJECT:-5762}

token=$(glab config get token --host "$host" 2>/dev/null || true)
[[ -n $token ]] || token=$(security find-generic-password -s "glab:$host" -w 2>/dev/null || true)
[[ -n $token ]] || { echo "no glab token for $host; run: glab auth login --hostname $host" >&2; exit 1; }

for file in "$@"; do
  [[ -f $file ]] || { echo "not found: $file" >&2; exit 1; }
  response=$(curl -sS -H "PRIVATE-TOKEN: $token" -F "file=@$file" \
    "https://$host/api/v4/projects/$project/uploads")
  markdown=$(printf '%s' "$response" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("markdown",""))')
  [[ -n $markdown ]] || { echo "upload failed for $file: $response" >&2; exit 1; }
  echo "$markdown"
done
