#!/bin/bash

set -e

fetch_remote_file() {
  curl --fail --silent --show-error $@
}
