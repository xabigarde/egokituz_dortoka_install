# Installing CUDA & darknet_ros (YOLO)

## Verify that NVIDIA drivers are installed
# [[ Following https://linuxconfig.org/how-to-install-the-nvidia-drivers-on-ubuntu-20-04-focal-fossa-linux ]]
# - Open "Software & Updates" & go to "Additional Drivers" TAB
# - Now choose any proprietary NVIDIA driver. NOTE: The higher the driver number the latest the version.

## Install CUDA:
# [[ Following https://linuxconfig.org/how-to-install-the-nvidia-drivers-on-ubuntu-20-04-focal-fossa-linux ]]
sudo apt update
sudo apt upgrade
sudo apt install nvidia-cuda-toolkit

# Verify CUDA installation:
nvcc --version

## Create and initialize the darknet workspace
cd ~
mkdir -p darknet_ros_ws/src
cd darknet_ros_ws
catkin_make_isolated -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=/usr/bin/gcc-8

# NOTE 1: We need to call 'catkin_make_isolated' or else it will fail to compile the packages in order later.
# NOTE 2: at the moment CUDA does not support GCC compiler higher then version 8, so we have to manually specify the version. Reference: https://linuxconfig.org/how-to-install-cuda-on-ubuntu-20-04-focal-fossa-linux

# Source the workspace setup:
source devel_isolated/setup.bash


## Clone the required packages:
cd src/
git clone --recursive git@github.com:leggedrobotics/darknet_ros.git
git clone -b egokituz_noetic https://github.com/xabigarde/gb_visual_detection_3d.git
git clone -b melodic https://github.com/IntelligentRoboticsLabs/gb_visual_detection_3d_msgs

# Add xabigarde remote and checkout branch egokituz_noetic:
cd darknet_ros/
git remote add xabigarde https://github.com/xabigarde/darknet_ros.git
git fetch xabigarde
git checkout egokituz_noetic

# Compile
cd ../../
catkin_make_isolated -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=/usr/bin/gcc-8

## Add setup.bash to your .bashrc:
# echo "source darknet_ros_ws/devel_isolated/setup.bash" >> ~/.bashrc
source devel_isolated/setup.bash

# to test installation, run these in two terminals:
# roslaunch darknet_ros darknet_ros.launch image:=/camera/color/image_raw
# roslaunch realsense2_camera d435.launch

