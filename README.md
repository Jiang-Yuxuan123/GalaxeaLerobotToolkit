# GalaxeaLeRobotToolkit
Convert rosbag / mcap to lerobot

## Enviroment Requirements
1. source Ros2 Humble setup.bash
2. conda env with python3.10
3. pip install dependencies below:
```bash
pip install git+https://github.com/OpenGalaxea/GalaxeaLeRobot.git
pip install loguru pyquaternion scipy
```
4. build hdas_msg
```bash
colcon build --packages-select hdas_msg
```

## Usage
Edit dataset_name, input_dir, output_dir and robot_type in run.sh, then
```bash
# build hdas_msg before source
source install/setup.bash 
bash run.sh
```
<!-- # 从机器人no.2电脑下载原始数据
rsync -avzh --progress --stats -e ssh nvidia@192.168.31.27:/home/nvidia/GalaxeaDataset/open_door_and_place_baozi /home/ziqi/git/data/real/mcap -->