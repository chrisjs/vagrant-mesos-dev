#!/bin/bash
#
# Generic utility functions used by various scripts.
#
# Author: Chris Schaefer
#
set -e

fetch_remote_file() {
  curl --fail --silent --show-error $@
}

