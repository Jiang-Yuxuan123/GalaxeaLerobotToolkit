#!/bin/bash
set -euo pipefail

usage() {
  echo "Usage: $0 <inputA> <outputA> <inputB> <outputB> [toolkit_dir]"
  echo "Runs two conversions back-to-back without rsync."
  exit 1
}

if [[ $# -lt 4 || $# -gt 5 ]]; then
  usage
fi

inputA="$1"
outputA="$2"
inputB="$3"
outputB="$4"
TOOLKIT_DIR="${5:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

MULTI_RUN="$TOOLKIT_DIR/multi-run.sh"

if [[ ! -f "$MULTI_RUN" ]]; then
  echo "Error: $MULTI_RUN not found." >&2
  exit 2
fi

overall_status=0

run_one() {
  local in_dir="$1"
  local out_dir="$2"

  echo -e "\n--- Running pipeline: input='$in_dir' output='$out_dir' ---"
  pushd "$TOOLKIT_DIR" >/dev/null || {
    echo "Warning: cannot enter $TOOLKIT_DIR" >&2
    overall_status=1
    return 1
  }

  if [[ -f install/setup.bash ]]; then
    echo "Sourcing install/setup.bash (temporarily disabling -u)"
    set +u
    # shellcheck disable=SC1091
    source install/setup.bash || {
      echo "Warning: sourcing install/setup.bash failed; continuing." >&2
      overall_status=1
    }
    set -u
  else
    echo "Note: install/setup.bash not found; continuing without sourcing." >&2
  fi

  echo "Executing: bash multi-run.sh \"$in_dir\" \"$out_dir\""
  if ! bash "$MULTI_RUN" "$in_dir" "$out_dir"; then
    echo "Warning: multi-run.sh failed for input='$in_dir'." >&2
    overall_status=1
  fi

  popd >/dev/null || true
}

run_one "$inputA" "$outputA"
run_one "$inputB" "$outputB"

echo -e "\nAll runs finished. overall_status=$overall_status"
exit "$overall_status"