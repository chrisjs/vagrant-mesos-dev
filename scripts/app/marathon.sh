#!/bin/bash
#
# Application spec to install Marathon.
#
# Depends on: util/util.sh
#
# Author: Chris Schaefer
#
set -e

MARATHON_VERSION=0.7.5
MARATHON_DIST_DIR=$APP_DIR/marathon-$MARATHON_VERSION
MARATHON_ARCHIVE_FILE_NAME=marathon-$MARATHON_VERSION.tgz
MARATHON_BASE_URL=http://downloads.mesosphere.com/marathon/v$MARATHON_VERSION
MARATHON_ARCHIVE_URL=$MARATHON_BASE_URL/$MARATHON_ARCHIVE_FILE_NAME
MARATHON_START_SCRIPT=$MARATHON_DIST_DIR/bin/start

ZOOKEEPER_URI=zk://127.0.0.1:2181
ZOOKEEPER_MESOS_PATH=mesos
ZOOKEEPER_MARATHON_PATH=marathon

install_marathon() {
  if [ ! -d $MARATHON_DIST_DIR ]
  then
    do_fetch_marathon
  else
    echo "Marathon already installed, skipping"
  fi

  do_start_marathon
}

do_fetch_marathon() {
  if [ ! -d $MARATHON_DIST_DIR ]
  then
    echo "Fetching $MARATHON_ARCHIVE_URL"
    fetch_remote_file "-o $APP_DIR/$MARATHON_ARCHIVE_FILE_NAME $MARATHON_ARCHIVE_URL"
    tar zxf $APP_DIR/$MARATHON_ARCHIVE_FILE_NAME -C $APP_DIR
  else
    echo "Extracted Marathon directory already exists, skipping"
  fi
}

do_start_marathon() {
  echo "Checking for running Marathon"

  if [ "x$(jps | grep marathon-assembly-$MARATHON_VERSION.jar)" = "x" ]
  then
    echo "Starting Marathon"
    nohup $MARATHON_START_SCRIPT --master $ZOOKEEPER_URI/$ZOOKEEPER_MESOS_PATH --zk $ZOOKEEPER_URI/$ZOOKEEPER_MARATHON_PATH  >> $LOG_DIR/marathon.log 2>&1 &
  else
    echo "Marathon already running"
  fi
}
