#!/bin/bash

set -e

ZOOKEEPER_VERSION=3.4.6
ZOOKEEPER_DIST_DIR=$APP_DIR/zookeeper-$ZOOKEEPER_VERSION
ZOOKEEPER_ARCHIVE_FILE_NAME=zookeeper-$ZOOKEEPER_VERSION.tar.gz
ZOOKEEPER_BASE_URL=http://apache.mirrors.tds.net/zookeeper/zookeeper-$ZOOKEEPER_VERSION
ZOOKEEPER_ARCHIVE_URL=$ZOOKEEPER_BASE_URL/$ZOOKEEPER_ARCHIVE_FILE_NAME
ZOOKEEPER_DATA_DIR=$APP_DIR/zookeeper-data
ZOOKEEPER_CONF=$ZOOKEEPER_DIST_DIR/conf/zoo.cfg
ZOOKEEPER_START_SCRIPT=$ZOOKEEPER_DIST_DIR/bin/zkServer.sh

install_zookeeper() {
  if [ ! -f $ZOOKEEPER_START_SCRIPT ]
  then
    do_fetch_zookeeper
    do_install_zookeeper
  else
    echo "Zookeeper already installed, skipping"
  fi

  do_start_zookeeper
}

do_fetch_zookeeper() {
  if [ ! -d $ZOOKEEPER_DIST_DIR ]
  then
    echo "Fetching $ZOOKEEPER_ARCHIVE_URL"
    fetch_remote_file "-o $APP_DIR/$ZOOKEEPER_ARCHIVE_FILE_NAME $ZOOKEEPER_ARCHIVE_URL"
    tar zxf $APP_DIR/$ZOOKEEPER_ARCHIVE_FILE_NAME -C $APP_DIR
  else
    echo "Extracted ZooKeeper directory already exists, skipping"
  fi
}

do_install_zookeeper() {
  if [ ! -d $ZOOKEEPER_DATA_DIR ]
  then
    echo "Creating ZooKeeper data dir at $ZOOKEEPER_DATA_DIR"
    mkdir $ZOOKEEPER_DATA_DIR
  else
    echo "ZooKeeper data dir already exists, skipping"
  fi

  if [ ! -f $ZOOKEEPER_CONF ]
  then
    echo "Creating ZooKeeper conf at $ZOOKEEPER_CONF"
    echo "tickTime=2000
initLimit=10
syncLimit=5
dataDir=$APP_DIR/zookeeper-data
clientPort=2181
" > $ZOOKEEPER_CONF
  else
    echo "ZooKeeper conf already exists, skipping"
  fi
}

do_start_zookeeper() {
  echo "Checking for running ZooKeeper"

  if [ "x$(jps | grep QuorumPeerMain)" = "x" ]
  then
    echo "Starting ZooKeeper"
    ZOO_LOG_DIR=$LOG_DIR $ZOOKEEPER_DIST_DIR/bin/zkServer.sh start
  else
    echo "ZooKeeper already running"
  fi
}

