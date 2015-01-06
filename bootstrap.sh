#!/bin/bash

set -e

APT_PACKAGES=(build-essential openjdk-6-jdk python-dev python-boto libcurl4-nss-dev libsasl2-dev maven libapr1-dev libsvn-dev)

BASE_DIR=$HOME
LOG_DIR=$BASE_DIR/logs

DEFAULT_INTERFACE=eth1
IP=`/sbin/ifconfig $DEFAULT_INTERFACE|grep inet|head -1|sed 's/\:/ /'|awk '{print $3}'`

MESOS_VERSION=0.21.0
MESOS_DIST_DIR=$BASE_DIR/mesos-$MESOS_VERSION
MESOS_ARCHIVE_FILE_NAME=mesos-$MESOS_VERSION.tar.gz
MESOS_BASE_URL=http://apache.mirrors.tds.net/mesos
MESOS_ARCHIVE_URL=$MESOS_BASE_URL/$MESOS_VERSION/$MESOS_ARCHIVE_FILE_NAME
MESOS_BUILD_DIR=$MESOS_DIST_DIR/build
MESOS_WORK_DIR=$BASE_DIR/mesos-work
MESOS_PORT=5050
MESOS_LIB_DIR=/usr/local/lib

ZOOKEEPER_VERSION=3.4.6
ZOOKEEPER_DIST_DIR=$BASE_DIR/zookeeper-$ZOOKEEPER_VERSION
ZOOKEEPER_ARCHIVE_FILE_NAME=zookeeper-$ZOOKEEPER_VERSION.tar.gz
ZOOKEEPER_BASE_URL=http://apache.mirrors.tds.net/zookeeper/zookeeper-$ZOOKEEPER_VERSION
ZOOKEEPER_ARCHIVE_URL=$ZOOKEEPER_BASE_URL/$ZOOKEEPER_ARCHIVE_FILE_NAME
ZOOKEEPER_DATA_DIR=$BASE_DIR/zookeeper-data
ZOOKEEPER_CONF=$ZOOKEEPER_DIST_DIR/conf/zoo.cfg

update_deps() {
  do_apt_update

  for i in ${APT_PACKAGES[@]}; do
    do_apt_install ${i}
  done
}

do_apt_update() {
  sudo apt-get update
}

do_apt_install() {
  sudo apt-get install -y "$@"
}

fetch_apps() {
  do_fetch_mesos
  do_fetch_zookeeper
}

install_apps() {
  if [ ! -d $LOG_DIR ]
  then
    echo "Creating app log dir"
    mkdir $LOG_DIR
  else
    echo "App log dir already exists, skipping"
  fi

  do_install_mesos
  do_install_zookeeper
}

start_apps() {
  do_start_zookeeper
  do_start_mesos_master
  do_start_mesos_slave
}

do_fetch_mesos() {
  if [ ! -d $MESOS_DIST_DIR ]
  then
    echo "Fetching $MESOS_ARCHIVE_URL"
    fetch_remote_file $MESOS_ARCHIVE_URL
    tar zxf $MESOS_ARCHIVE_FILE_NAME
  else
    echo "Extracted mesos source directory already exists, skipping"
  fi
}

do_fetch_zookeeper() {
  if [ ! -d $ZOOKEEPER_DIST_DIR ]
  then
    echo "Fetching $ZOOKEEPER_ARCHIVE_URL"
    fetch_remote_file $ZOOKEEPER_ARCHIVE_URL
    tar zxf $ZOOKEEPER_ARCHIVE_FILE_NAME
  else
    echo "Extracted ZooKeeper directory already exists, skipping"
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
    echo "Building/installing Mesos"
    cd $MESOS_DIST_DIR ; mkdir build ; cd build ; ../configure ; make ; make check ; sudo make install ; cd $BASE_DIR
  else
    echo "Mesos build directory already exists, skipping"
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
dataDir=$BASE_DIR/zookeeper-data
clientPort=2181
" > $ZOOKEEPER_CONF
  else
    echo "ZooKeeper conf already exists, skipping"
  fi
}

do_start_zookeeper() {
  echo "Checking for running ZooKeeper"

  if [ "x`jps | grep QuorumPeerMain`" = "x" ]
  then
    echo "Starting ZooKeeper"
    ZOO_LOG_DIR=$LOG_DIR $ZOOKEEPER_DIST_DIR/bin/zkServer.sh start
  else
    echo "ZooKeeper already running"
  fi
}

do_start_mesos_master() {
  echo "Checking for running mesos master"

  if [ "x`pidof mesos-master`" = "x" ]
  then
    echo "Starting mesos master"
    LD_LIBRARY_PATH=$MESOS_LIB_DIR${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH} nohup mesos-master --ip=$IP --work_dir=$MESOS_WORK_DIR >> $LOG_DIR/mesos-master.log 2>&1 &
  else
    echo "Mesos master already running"
  fi
}

do_start_mesos_slave() {
  echo "Checking for running mesos slave"

  if [ "x`pidof mesos-slave`" = "x" ]
  then
    echo "Starting mesos slave"
    LD_LIBRARY_PATH=$MESOS_LIB_DIR${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH} nohup mesos-slave --master=$IP:$MESOS_PORT >> $LOG_DIR/mesos-slave.log 2>&1 &
  else
    echo "Mesos slave already running"
  fi
}

fetch_remote_file() {
  curl -O --fail --silent --show-error "$@"
}

update_deps
fetch_apps
install_apps
start_apps
