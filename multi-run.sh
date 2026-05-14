#!/bin/bash
# Parameterized run.sh for dataset conversion
# Usage:
#   ./run.sh [input_dir] [output_dir]
# If args are omitted, falls back to the existing defaults.

dataset_name=debug
# current defaults (kept from previous file)
default_input_dir="/home/ziqi/git/data/real/mcap/test/1"
default_output_dir="/home/ziqi/git/data/real/mcap/test/lerobot/1"

# Allow overriding by positional parameters
input_dir="${1:-$default_input_dir}"
output_dir="${2:-$default_output_dir}"

robot_type=R1Pro # options: R1Pro, R1Lite

export SAVE_VIDEO=1
export USE_H264=1
export USE_COMPRESSION=0
export IS_COMPUTE_EPISODE_STATS_IMAGE=1
export MAX_PROCESSES=8
export USE_ROS1=0
export USE_TRANSLATION=0

echo "Running dataset conversion"
echo "  dataset_name: $dataset_name"
echo "  input_dir:    $input_dir"
echo "  output_dir:   $output_dir"
echo "  robot_type:   $robot_type"

python -m dataset_converter \
    --input_dir "$input_dir" \
    --output_dir "$output_dir" \
    --robot_type $robot_type \
    --dataset_name $dataset_name
