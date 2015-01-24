#!/bin/bash

set -e

fetch_remote_file() {
  curl -O --fail --silent --show-error $@
}
