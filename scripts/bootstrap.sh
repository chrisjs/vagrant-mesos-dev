#!/bin/bash

set -e

BASE_DIR=$HOME
LOG_DIR=$BASE_DIR/logs

SCRIPTS_DIR=$BASE_DIR/scripts
SCRIPTS_OS_DIR=$SCRIPTS_DIR/os
SCRIPTS_APP_DIR=$SCRIPTS_DIR/app
SCRIPTS_UTIL_DIR=$SCRIPTS_DIR/util

APPS=(docker zookeeper mesos)

DEFAULT_PLATFORM_ARCH=x86_64
PLATFORM_ARCH=$DEFAULT_PLATFORM_ARCH

DEFAULT_OS_NAME=Linux
OS_NAME=$DEFAULT_OS_NAME

pre_install() {
  check_platform
  create_log_dir
  source_deps
}

check_platform() {
  UNAME=`uname -a`

  if [[ $UNAME == Linux*_64* ]]
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

  echo "Starting build for $OS_NAME on $PLATFORM_ARCH"
}

create_log_dir() {
  if [ ! -d $LOG_DIR ]
  then
    echo "Creating app log dir"
    mkdir $LOG_DIR
  else
    echo "App log dir already exists, skipping"
  fi
}

source_deps() {
    source $SCRIPTS_UTIL_DIR/util.sh
}

install() {
  install_os_deps

  for i in ${APPS[@]}; do
    source $SCRIPTS_APP_DIR/${i}.sh
    install_${i}
  done
}

pre_install
install
