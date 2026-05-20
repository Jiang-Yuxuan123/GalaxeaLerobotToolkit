#!/bin/bash
set -uo pipefail

if [[ $# -ne 6 ]]; then
  echo "Usage: $0 <srcA> <srcB> <destC> <destD> <outE> <outF>"
  echo "Example: $0 /path/to/A /path/to/B /path/to/C /path/to/D /path/to/E /path/to/F"
  echo "Where srcA and srcB are the source directories to sync from,"
  echo "destC and destD are the destination directories to sync to,"
  echo "and outE and outF are the output directories for the two runs."
  exit 1
fi

srcA="$1"
srcB="$2"
destC="$3"
destD="$4"
outE="$5"
outF="$6"

RUN_SH="/home/ziqi/git/galaxea/GalaxeaLeRobotToolkit/multi-run.sh"
TOOLKIT_DIR="$(dirname "$RUN_SH")"

if [[ ! -f "$RUN_SH" ]]; then
  echo "Error: $RUN_SH not found. Aborting run steps." >&2
  exit 2
fi

overall_status=0

record_failure() {
  overall_status=1
}

sync_pair() {
  local src="$1"
  local dest="$2"

  echo "\nSyncing: $src -> $dest"
  if [[ ! -e "$src" ]]; then
    echo "Warning: source '$src' does not exist. Skipping." >&2
    record_failure
    return 0
  fi

  mkdir -p "$dest"
  rsync -avh --progress "$src"/ "$dest"/
  local rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "Warning: rsync failed for $src -> $dest (exit code $rc), continuing." >&2
    record_failure
  fi
  return 0
}

run_pipeline() {
  local input_dir="$1"
  local output_dir="$2"

  echo "\n--- Running pipeline in $TOOLKIT_DIR with input=$input_dir output=$output_dir ---"
  pushd "$TOOLKIT_DIR" >/dev/null || {
    echo "Warning: cannot enter $TOOLKIT_DIR, skipping this run." >&2
    record_failure
    return 0
  }

  if [[ -f install/setup.bash ]]; then
    echo "Sourcing install/setup.bash (temporarily disabling -u)"
    set +u
    # shellcheck disable=SC1091
    source install/setup.bash
    local source_rc=$?
    set -u
    if [[ $source_rc -ne 0 ]]; then
      echo "Warning: sourcing install/setup.bash failed (exit code $source_rc), continuing." >&2
      record_failure
    fi
  else
    echo "Warning: install/setup.bash not found; continuing without sourcing." >&2
  fi

  echo "Executing: bash multi-run.sh \"$input_dir\" \"$output_dir\""
  bash multi-run.sh "$input_dir" "$output_dir"
  local run_rc=$?
  if [[ $run_rc -ne 0 ]]; then
    echo "Warning: multi-run.sh failed with exit code $run_rc, continuing." >&2
    record_failure
  fi

  popd >/dev/null || true
  return 0
}

echo "Starting rsync operations..."
sync_pair "$srcA" "$destC"
sync_pair "$srcB" "$destD"

# First run: input=destC, output=outE
run_pipeline "$destC" "$outE"

# Second run: input=destD, output=outF
run_pipeline "$destD" "$outF"

echo "\nAll runs finished. Done."
exit "$overall_status"
#!/bin/bash
set -euo pipefail

if [[ $# -ne 6 ]]; then
  echo "Usage: $0 <srcA> <srcB> <destC> <destD> <outE> <outF>"
  echo "Example: $0 /path/to/A /path/to/B /path/to/C /path/to/D /path/to/E /path/to/F"
  echo "Where srcA and srcB are the source directories to sync from,"
  echo "destC and destD are the destination directories to sync to,"
overall_status=0
  echo "and outE and outF are the output directories to set in run.sh for the two runs."
  exit 1
fi

srcA="$1"
srcB="$2"
destC="$3"
destD="$4"
outE="$5"
outF="$6"
  if rsync -avh --progress "$src"/ "$dest"/; then
    return 0
  fi
  local rc=$?
  echo "Warning: rsync failed for $src -> $dest (exit code $rc), continuing." >&2
  overall_status=1
  return 0
echo "Starting rsync operations..."

sync_pair() {
  local src="$1"
  local dest="$2"
  echo "\nSyncing: $src -> $dest"
  if [[ ! -e "$src" ]]; then
    echo "Warning: source '$src' does not exist. Skipping."
    return
  fi
  mkdir -p "$dest"
  rsync -avh --progress "$src"/ "$dest"/
}

sync_pair "$srcA" "$destC"
sync_pair "$srcB" "$destD"

RUN_SH="/home/ziqi/git/galaxea/GalaxeaLeRobotToolkit/multi-run.sh"
TOOLKIT_DIR="$(dirname "$RUN_SH")"

if [[ ! -f "$RUN_SH" ]]; then
  echo "Error: $RUN_SH not found. Aborting run steps." >&2
  exit 2
fi

run_pipeline() {
  local input_dir="$1"
  local output_dir="$2"
  echo "\n--- Running pipeline in $TOOLKIT_DIR with input=$input_dir output=$output_dir ---"
  pushd "$TOOLKIT_DIR" >/dev/null
  if [[ -f install/setup.bash ]]; then
    echo "Sourcing install/setup.bash (temporarily disabling -u)"
    # Temporarily disable -u (nounset) so sourcing won't fail on unset variables
    set +u
  bash multi-run.sh "$input_dir" "$output_dir"
  local rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "Warning: multi-run.sh failed with exit code $rc, continuing." >&2
    overall_status=1
      set -u
    return 0
      return 1
    fi
    set -u
  else
    echo "Warning: install/setup.bash not found; continuing without sourcing." >&2
  fi
  echo "Executing: bash multi-run.sh \"$input_dir\" \"$output_dir\""
  if ! bash multi-run.sh "$input_dir" "$output_dir"; then
    local rc=$?
    echo "multi-run.sh failed with exit code $rc" >&2
    popd >/dev/null
    return $rc
exit "$overall_status"
  fi
  popd >/dev/null
  return 0
}

# First run: input=destC, output=outE
run_pipeline "$destC" "$outE"

# Second run: input=destD, output=outF
run_pipeline "$destD" "$outF"

echo "\nAll runs finished. Done."
