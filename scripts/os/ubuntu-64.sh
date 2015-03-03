#!/bin/bash
#
# Functions to execute tasks that are specific to the Ubuntu Linux distribution.
#
# The install_os_deps function is called from the bootstrap script and required
# for any supported operating systems to install base OS dependencies.
#
# Author: Chris Schaefer
#
set -e

APT_PACKAGES=(build-essential openjdk-7-jdk python-dev python-boto libcurl4-nss-dev libsasl2-dev maven libapr1-dev libsvn-dev cgroup-lite git)

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
