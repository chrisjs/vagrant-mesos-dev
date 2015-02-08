#!/bin/bash

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
