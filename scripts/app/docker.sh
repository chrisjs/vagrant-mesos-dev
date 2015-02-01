#!/bin/bash

set -e

DOCKER_VERSION=1.4.0
DOCKER_DIST_FILE_NAME=docker-$DOCKER_VERSION
DOCKER_DIST_FILE=$BASE_DIR/docker-$DOCKER_VERSION
DOCKER_BASE_URL=https://get.docker.com/builds/$OS_NAME/$PROCESSOR_ARCH
DOCKER_FILE_URL=$DOCKER_BASE_URL/docker-$DOCKER_VERSION
DOCKER_INSTALL_PATH=/usr/sbin

install_docker() {
  do_fetch_docker
  do_install_docker
  do_start_docker
}

do_fetch_docker() {
  if [ ! -f $DOCKER_INSTALL_PATH/$DOCKER_DIST_FILE_NAME ]
  then
    echo "Fetching $DOCKER_FILE_URL"
    fetch_remote_file "-o $DOCKER_DIST_FILE $DOCKER_FILE_URL"
  else
    echo "Docker file already exists, skipping"
  fi
}

do_install_docker() {
  if [ ! -f $DOCKER_INSTALL_PATH/$DOCKER_DIST_FILE_NAME ]
  then
    echo "Installing docker"
    sudo chmod +x $DOCKER_DIST_FILE ; sudo mv $DOCKER_DIST_FILE $DOCKER_INSTALL_PATH ;\
     sudo ln -sf $DOCKER_INSTALL_PATH/$DOCKER_DIST_FILE_NAME $DOCKER_INSTALL_PATH/docker
  else
    echo "Docker binary exists, skipping"
  fi
}

do_start_docker() {
  echo "Checking for running docker"

  if [ "x`pidof docker`" = "x" ]
  then
    echo "Starting docker"
    sudo $DOCKER_INSTALL_PATH/docker -d >> $LOG_DIR/docker.log 2>&1 &
  else
    echo "Docker already running"
  fi
}
