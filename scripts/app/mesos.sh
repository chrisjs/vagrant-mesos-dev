#!/bin/bash

set -e

MESOS_VERSION=0.21.1
MESOS_DIST_DIR=$APP_DIR/mesos-$MESOS_VERSION
MESOS_ARCHIVE_FILE_NAME=mesos-$MESOS_VERSION.tar.gz
MESOS_BASE_URL=http://apache.mirrors.tds.net/mesos
MESOS_ARCHIVE_URL=$MESOS_BASE_URL/$MESOS_VERSION/$MESOS_ARCHIVE_FILE_NAME
MESOS_BUILD_DIR=$MESOS_DIST_DIR/build
MESOS_WORK_DIR=$APP_DIR/mesos-work
MESOS_MASTER_PORT=5050
MESOS_LIB_DIR=/usr/local/lib
MESOS_MASTER_IP=0.0.0.0
MESOS_ZOOKEEPER_URI=zk://127.0.0.1:2181/mesos
LD_LIBRARY_PATH=$MESOS_LIB_DIR${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}

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
    fetch_remote_file "-o $APP_DIR/$MESOS_ARCHIVE_FILE_NAME $MESOS_ARCHIVE_URL"
    tar zxf $APP_DIR/$MESOS_ARCHIVE_FILE_NAME -C $APP_DIR
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

  pushd $MESOS_BUILD_DIR  > /dev/null

  if [ ! -f .complete ]
  then
    if [ ! -f .configcomp ]
    then
      echo "Configuring Mesos"
      ../configure ; touch .configcomp
    else
      echo "Configuring Mesos already complete, skipping"
    fi

    if [ ! -f .makecomp ]
    then
      echo "Making Mesos"
      make ; touch .makecomp
    else
      echo "Make of Mesos already complete, skipping"
    fi

    if [ ! -f .makechkcomp ]
    then
      echo "Running Mesos checks"
      make check ; touch .makechkcomp
    else
      echo "Running of Mesos checks already complete, skipping"
    fi

    if [ ! -f .makeinscomp ]
    then
      echo "Installing Mesos"
      sudo make install ; touch .makeinscomp
    else
      echo "Install of Mesos already complete, skipping"
    fi

    touch .complete
  else
    echo "Mesos already built and installed, skipping"
  fi

  popd > /dev/null
}

do_start_mesos_master() {
  echo "Checking for running mesos master"

  if [ "x$(which mesos-master)" = "x" ]
  then
    echo "No mesos-master binary found, not starting"
  else
    if [ "x$(pidof mesos-master)" = "x" ]
    then
      echo "Starting mesos master"
      LD_LIBRARY_PATH=$LD_LIBRARY_PATH nohup mesos-master --ip=$MESOS_MASTER_IP --port=$MESOS_MASTER_PORT --work_dir=$MESOS_WORK_DIR --zk=$MESOS_ZOOKEEPER_URI --quorum=1 >> $LOG_DIR/mesos-master.log 2>&1 &
    else
      echo "Mesos master already running"
    fi
  fi
}

do_start_mesos_slave() {
  echo "Checking for running mesos slave"

  if [ "x$(which mesos-slave)" = "x" ]
  then
    echo "No mesos-slave binary found, not starting"
  else
    if [ "x$(pidof mesos-slave)" = "x" ]
    then
      echo "Starting mesos slave"
      LD_LIBRARY_PATH=$LD_LIBRARY_PATH nohup sudo mesos-slave --master=$MESOS_ZOOKEEPER_URI --containerizers=docker,mesos >> $LOG_DIR/mesos-slave.log 2>&1 &
    else
      echo "Mesos slave already running"
    fi
  fi
}
