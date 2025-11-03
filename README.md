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

## Usage
Edit dataset_name, input_dir, output_dir and robot_type in run.sh, then
```bash
bash run.sh
```
