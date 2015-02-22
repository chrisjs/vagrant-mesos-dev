#!/bin/bash
#
# Main entry point to setup the development environment, invoked from either
# Vagrant or directly. This script will check for a supported platform, create the
# expected directory structure for logs and applications if needed and install
# applications specified in the APP_BUILD_SPECS variable.
#
# New applications can be built simply by adding a build script to the app
# directory and inserting its name (filename without extension) to the
# APP_BUILD_SPECS variable. Order is preserved so any dependencies should be
# added earlier in the list. Every app spec should have a function with the
# application name as defined in the APP_BUILD_SPECS variable, prefixed by
# "install_" which will be called by this script.
#
# Depends on: os/, util/, app/
#
# Author: Chris Schaefer
#
set -e

BASE_DIR=${BASE_DIR=$HOME}
APP_DIR=$BASE_DIR/application
LOG_DIR=$BASE_DIR/logs
SCRIPTS_DIR=$BASE_DIR/scripts
SCRIPTS_OS_DIR=$SCRIPTS_DIR/os
SCRIPTS_APP_BUILD_SPECS_DIR=$SCRIPTS_DIR/app
SCRIPTS_UTIL_DIR=$SCRIPTS_DIR/util
APP_BUILD_SPECS=(docker zookeeper mesos marathon)
PROCESSOR_ARCH=$(uname -p)
OS_NAME=$(uname -s)

pre_install() {
  echo "Base dir at: $BASE_DIR"

  check_platform
  create_log_dir
  create_app_dir
  source_deps
}

check_platform() {
  if [ "$OS_NAME" = Linux ] && [ "$PROCESSOR_ARCH" = x86_64 ]
  then
    if [ ! -f /etc/debian_version ]
    then
      echo "Unsupported linux distro"
      exit 1
    else
      source $SCRIPTS_OS_DIR/ubuntu-64.sh
    fi
  else
    echo "Unsupported OS"
    exit 1
  fi

  echo "Starting build for $OS_NAME on $PROCESSOR_ARCH"
}

create_log_dir() {
  if [ ! -d $LOG_DIR ]
  then
    echo "Creating app log dir: $LOG_DIR"
    mkdir $LOG_DIR
  else
    echo "App log dir ($LOG_DIR) already exists, skipping"
  fi
}

create_app_dir() {
  if [ ! -d $APP_DIR ]
  then
    echo "Creating applications dir at: $APP_DIR"
    mkdir $APP_DIR
  else
    echo "Application dir ($APP_DIR) already exists, skipping"
  fi
}

source_deps() {
  if [ ! -f $SCRIPTS_UTIL_DIR/util.sh ]
  then
    echo "Could not source util script at: $SCRIPTS_UTIL_DIR/util.sh"
    exit 1
  fi

  source $SCRIPTS_UTIL_DIR/util.sh
}

install() {
  install_os_deps

  for i in ${APP_BUILD_SPECS[@]}; do
    if [ ! -f $SCRIPTS_APP_BUILD_SPECS_DIR/${i}.sh ]
    then
      echo "Could not source application file at: $SCRIPTS_APP_BUILD_SPECS_DIR/${i}.sh"
      exit 1
    else
      source $SCRIPTS_APP_BUILD_SPECS_DIR/${i}.sh
      install_${i}
    fi
  done
}

pre_install
install

