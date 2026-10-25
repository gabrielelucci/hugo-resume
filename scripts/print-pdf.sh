#!/bin/sh
# Print every language of the resume to a one-page A4 PDF, as the browser's
# "Print -> Save as PDF" would. Used by .gitlab-ci.yml; also runs locally.
#
#   scripts/print-pdf.sh OUT_DIR
#
# Files are named gabriele-lucci-resume-<lang>-<short sha>-<commit date>.pdf.
# The phone number comes from HUGO_RESUME_PHONE: set, it must appear in every
# PDF; unset or empty, it must not. Needs hugo, chromium, wget and pdfinfo.
# Never add `set -x`: it would print the phone number to the job log.
set -eu

out=${1:?usage: $0 OUT_DIR}
port=${HUGO_PORT:-1313}
base="http://127.0.0.1:$port/resume"
sha=${CI_COMMIT_SHORT_SHA:-$(git rev-parse --short HEAD)}
timestamp=${CI_COMMIT_TIMESTAMP:-$(git log -1 --format=%cI)}
date=$(printf '%s' "$timestamp" | cut -c1-10)

chromium=$(command -v chromium-browser || command -v chromium) || {
  echo "chromium not found" >&2
  exit 1
}

log=$(mktemp)
hugo server --renderToMemory --disableLiveReload \
  --bind 127.0.0.1 --port "$port" >"$log" 2>&1 &
hugo_pid=$!
trap 'kill "$hugo_pid" 2>/dev/null || true; rm -f "$log" "$log.chromium"' EXIT

tries=60
until wget -q --spider "$base/" 2>/dev/null; do
  tries=$((tries - 1))
  if [ "$tries" -le 0 ] || ! kill -0 "$hugo_pid" 2>/dev/null; then
    echo "hugo server did not come up:" >&2
    cat "$log" >&2
    exit 1
  fi
  sleep 1
done

mkdir -p "$out"
want_phone=${HUGO_RESUME_PHONE:+yes}
status=0
for lang in en it; do
  url="$base/"
  [ "$lang" = en ] || url="$base/$lang/"
  file="$out/gabriele-lucci-resume-$lang-$sha-$date.pdf"

  # The theme renders a phone contact item with the fa-phone icon (and a tel:
  # link when it comes from the environment), and drops it when unset.
  if wget -qO- "$url" | grep -qE 'fa-phone|href="tel:[^"]'; then has_phone=yes; else has_phone=; fi
  if [ "$has_phone" != "$want_phone" ]; then
    if [ -n "$want_phone" ]; then
      echo "$lang: HUGO_RESUME_PHONE is set but the page has no phone number" >&2
    else
      echo "$lang: HUGO_RESUME_PHONE is unset but the page has a phone number" >&2
    fi
    exit 1
  fi

  if ! "$chromium" --headless --no-sandbox --disable-gpu --disable-dev-shm-usage \
    --no-pdf-header-footer --virtual-time-budget=5000 \
    --print-to-pdf="$file" "$url" >"$log.chromium" 2>&1; then
    echo "$lang: chromium failed:" >&2
    cat "$log.chromium" >&2
    exit 1
  fi

  pages=$(pdfinfo "$file" | awk '/^Pages:/ { print $2 }')
  if [ "$pages" = 1 ]; then
    echo "$file"
  else
    echo "$file: $pages pages; the resume must print on one page" >&2
    status=1
  fi
done
exit "$status"
