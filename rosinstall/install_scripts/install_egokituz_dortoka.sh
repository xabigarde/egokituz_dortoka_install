#!/bin/bash

#cd $WORKSPACE_ROOT

if [ -z $WORKSPACE_ROOT ]; then
  echo "Variable WORKSPACE_ROOT not set, make sure the workspace is set up properly!"
else
  echo "Installing EGOKITUZ Dortoka software setup ..."

  cd $WORKSPACE_ROOT

  # List the rosinstall files containing any packages we wish to install here
  wstool merge rosinstall/optional/egokituz_flexible_navigation.rosinstall
  wstool merge rosinstall/optional/chris_third_party.rosinstall
  wstool merge rosinstall/optional/egokituz_turtlebot.rosinstall

  #--------------------- common code below here ----------------------------
  # Optionally check if update is requested. Not doing update saves some
  # time when called from other scripts
  while [ -n "$1" ]; do
    case $1 in
    --no_ws_update)
        UPDATE_WORKSPACE=1
        ;;
    esac

    shift
  done

  if [ -n "$UPDATE_WORKSPACE" ]; then
    echo "Not updating workspace as --no_ws_update was set"
  else
    wstool update
    rosdep update
    rosdep install -r --from-path . --ignore-src
  fi

fi

# Add CATKIN_IGNORE to broken packages:
echo "Adding CATKIN_IGNORE files to broken yujin_ocs/yocs_ar_* packages..."
cd $WORKSPACE_ROOT
touch src/yujin_ocs/yocs_ar_marker_tracking/CATKIN_IGNORE
touch src/yujin_ocs/yocs_ar_pair_approach/CATKIN_IGNORE
touch src/yujin_ocs/yocs_ar_pair_tracking/CATKIN_IGNORE
