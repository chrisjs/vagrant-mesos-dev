#!/bin/bash

set -e

MESOS_VERSION=0.21.0
MESOS_DIST_DIR=$BASE_DIR/mesos-$MESOS_VERSION
MESOS_ARCHIVE_FILE_NAME=mesos-$MESOS_VERSION.tar.gz
MESOS_BASE_URL=http://apache.mirrors.tds.net/mesos
MESOS_ARCHIVE_URL=$MESOS_BASE_URL/$MESOS_VERSION/$MESOS_ARCHIVE_FILE_NAME
MESOS_BUILD_DIR=$MESOS_DIST_DIR/build
MESOS_WORK_DIR=$BASE_DIR/mesos-work
MESOS_MASTER_PORT=5050
MESOS_LIB_DIR=/usr/local/lib
MESOS_MASTER_IP=0.0.0.0

install_mesos() {
  do_fetch_mesos
  do_install_mesos
  do_start_mesos_master
  do_start_mesos_slave
}

do_fetch_mesos() {
  if [ ! -d $MESOS_DIST_DIR ]
  then
    echo "Fetching $MESOS_ARCHIVE_URL"
    fetch_remote_file "-o $BASE_DIR/$MESOS_ARCHIVE_FILE_NAME $MESOS_ARCHIVE_URL"
    tar zxf $BASE_DIR/$MESOS_ARCHIVE_FILE_NAME -C $BASE_DIR
  else
    echo "Extracted Mesos source directory already exists, skipping"
  fi
}

do_install_mesos() {
  if [ ! -d $MESOS_WORK_DIR ]
  then
    echo "Creating Mesos work dir at $MESOS_WORK_DIR"
    mkdir $MESOS_WORK_DIR
  else
    echo "Mesos work dir already exists, skipping"
  fi

  if [ ! -d $MESOS_BUILD_DIR ]
  then
    echo "Creating Mesos build dir at $MESOS_BUILD_DIR"
    mkdir $MESOS_BUILD_DIR
  else
    echo "Mesos build directory already exists, skipping"
  fi

  if [ ! -f $MESOS_BUILD_DIR/.complete ]
  then
    echo "Building/installing Mesos"

    pushd $MESOS_BUILD_DIR

    ../configure ; make ; make check ; sudo make install ; touch .complete

    popd
  else
    echo "Mesos already built and installed, skipping"
  fi
}

do_start_mesos_master() {
  echo "Checking for running mesos master"

  if [ "x`which mesos-master`" = "x" ]
  then
    echo "No mesos-master binary found, not starting"
  else
    if [ "x`pidof mesos-master`" = "x" ]
    then
      echo "Starting mesos master"
      LD_LIBRARY_PATH=$MESOS_LIB_DIR${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH} nohup mesos-master --ip=$MESOS_MASTER_IP --port=$MESOS_MASTER_PORT --work_dir=$MESOS_WORK_DIR >> $LOG_DIR/mesos-master.log 2>&1 &
    else
      echo "Mesos master already running"
    fi
  fi
}

do_start_mesos_slave() {
  echo "Checking for running mesos slave"

  if [ "x`which mesos-slave`" = "x" ]
  then
    echo "No mesos-slave binary found, not starting"
  else
    if [ "x`pidof mesos-slave`" = "x" ]
    then
      echo "Starting mesos slave"
      LD_LIBRARY_PATH=$MESOS_LIB_DIR${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH} nohup mesos-slave --master=$MESOS_MASTER_IP:$MESOS_MASTER_PORT >> $LOG_DIR/mesos-slave.log 2>&1 &
    else
      echo "Mesos slave already running"
    fi
  fi
}
