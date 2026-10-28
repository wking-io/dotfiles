#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'USAGE'
Usage: render-with-prod-css.sh <fragment.html> <out.png> [dark|light] [width] [height] [title]

Render an HTML fragment (for example a component's container.innerHTML dumped
from a test) inside a Dash-like page that loads the live production Dash
stylesheet, then screenshot it with headless Chrome at 2x.

DIAGNOSIS ONLY. The output is a simulated render, not the app. Never attach it
to an MR; MR screenshots come from the local server in the Rex `prod` tab.

The page mirrors Dash's base: the legacy @layer cf rules from initStyles.ts
(button { border: none }, no Tailwind preflight), body bg-kumo-canvas, and
dark mode via html.dark-mode + data-mode="dark". The fragment sits in a
bg-kumo-base card with an optional title.

Defaults: mode=dark, width=948, height=372, no title.
Env: PROD_CSS=<path> reuses a downloaded stylesheet instead of fetching.
USAGE
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi
if [[ $# -lt 2 ]]; then
  usage
  exit 1
fi

fragment=$1
out=$2
mode=${3:-dark}
width=${4:-948}
height=${5:-372}
title=${6:-}
chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

[[ -f $fragment ]] || { echo "fragment not found: $fragment" >&2; exit 1; }
[[ -x $chrome ]] || { echo "Google Chrome not found at $chrome" >&2; exit 1; }

workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

css=${PROD_CSS:-}
if [[ -z $css ]]; then
  # Use the <link rel="stylesheet"> href. The page also embeds an asset map
  # whose app.*.css keys are build aliases, not the served stylesheet.
  css_path=$(curl -sL https://dash.cloudflare.com/ |
    grep -oE '<link[^>]+rel="stylesheet"[^>]+href="/assets/app\.[^"]+\.css"' |
    grep -oE '/assets/app\.[^"]+\.css' | head -1)
  [[ -n $css_path ]] || { echo "could not find the app stylesheet link on dash.cloudflare.com" >&2; exit 1; }
  css="$workdir/app.css"
  curl -sL "https://dash.cloudflare.com$css_path" -o "$css"
fi

html_attrs=''
[[ $mode == dark ]] && html_attrs='class="dark-mode" data-mode="dark"'
title_html=''
[[ -n $title ]] && title_html="<div class=\"mb-3 text-base font-medium\">$title</div>"

cat >"$workdir/page.html" <<HTML
<!doctype html><html $html_attrs><head><meta charset="utf-8">
<style>@layer cf { * {box-sizing:border-box} html,body,button{font-size:16px} body{margin:0;line-height:1.5} button {border:none} }</style>
<link rel="stylesheet" href="file://$css"></head>
<body class="bg-kumo-canvas text-kumo-default" style="padding:24px;width:$((width - 48))px">
<div class="rounded-lg ring ring-kumo-line bg-kumo-base p-4">
$title_html
$(cat "$fragment")
</div></body></html>
HTML

"$chrome" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=2 \
  --allow-file-access-from-files --screenshot="$out" --window-size="$width,$height" \
  "file://$workdir/page.html" 2>/dev/null

[[ -s $out ]] || { echo "screenshot failed: $out" >&2; exit 1; }
echo "$out"
