#!/bin/bash

set -e

APT_PACKAGES=(build-essential openjdk-6-jdk python-dev python-boto libcurl4-nss-dev libsasl2-dev maven libapr1-dev libsvn-dev)

MESOS_VERSION=0.21.0
MESOS_ARCHIVE_FILE_NAME=mesos-$MESOS_VERSION.tar.gz
MESOS_BASE_URL=http://apache.mirrors.tds.net/mesos

ZOOKEEPER_VERSION=3.4.6
ZOOKEEPER_ARCHIVE_FILE_NAME=zookeeper-$ZOOKEEPER_VERSION.tar.gz
ZOOKEEPER_BASE_URL=http://apache.mirrors.tds.net/zookeeper/zookeeper-$ZOOKEEPER_VERSION

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

install_apps() {
  do_fetch_mesos
  do_fetch_zookeeper
}

do_fetch_mesos() {
  if [ ! -d "mesos-$MESOS_VERSION" ]
  then
    echo "Fetching $MESOS_ARCHIVE_FILE_NAME"
    fetch_remote_file $MESOS_BASE_URL/$MESOS_VERSION/$MESOS_ARCHIVE_FILE_NAME
    tar zxf $MESOS_ARCHIVE_FILE_NAME
  else
    echo "Extracted mesos source directory already exists, skipping"
  fi
}

do_fetch_zookeeper() {
  if [ ! -d "zookeeper-$ZOOKEEPER_VERSION" ]
  then
    echo "Fetching $ZOOKEEPER_ARCHIVE_FILE_NAME"
    fetch_remote_file $ZOOKEEPER_BASE_URL/$ZOOKEEPER_ARCHIVE_FILE_NAME
    tar zxf $ZOOKEEPER_ARCHIVE_FILE_NAME
  else
    echo "Extracted ZooKeeper directory already exists, skipping"
  fi
}

fetch_remote_file() {
  curl -O --fail --silent --show-error "$@"
}

update_deps
install_apps
