#!/bin/bash
dataset_name=debug
input_dir=/home/ziqi/git/data/real/mcap/opendoor_place_baozi_closedoor/20260120/20260120_heat_food
output_dir=/home/ziqi/git/data/real/lerobot_data/opendoor_place_baozi_closedoor/20260120
robot_type=R1Pro # options: R1Pro, R1Lite

export SAVE_VIDEO=1 
export USE_H264=0
export USE_COMPRESSION=0
export IS_COMPUTE_EPISODE_STATS_IMAGE=1
export MAX_PROCESSES=8
export USE_ROS1=0
export USE_TRANSLATION=0

python -m dataset_converter \
    --input_dir $input_dir \
    --output_dir $output_dir \
    --robot_type $robot_type \
    --dataset_name $dataset_name
