#!/bin/bash

set -e

APT_PACKAGES=(build-essential openjdk-6-jdk python-dev python-boto libcurl4-nss-dev libsasl2-dev maven libapr1-dev libsvn-dev cgroup-lite golang)

install_os_deps() {
  do_apt_update

  for i in ${APT_PACKAGES[@]}; do
    do_apt_install ${i}
  done
}

do_apt_update() {
  sudo apt-get update
}

do_apt_install() {
  sudo apt-get install -y $@
}
