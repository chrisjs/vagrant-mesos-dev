#!/bin/sh
#
# Creates a versioned archive of the scripts directory suitable for
# uploading and running on an OS instance. Typically this would be
# used if you wanted to create a distribution archive and use it
# without vagrant or with a pre-existing vagrant VM but not use
# its provisioning abilities.
#
# Author: Chris Schaefer
#
set -e

BASE_DIR="$(cd "$( dirname "$0" )" && pwd)"
VERSION=$(cat $BASE_DIR/VERSION)
ARCHIVE_FILE_NAME=mesos-dev-$VERSION.tar.gz

echo "Building standalone distribution archive for version: $VERSION"

tar zcf $BASE_DIR/$ARCHIVE_FILE_NAME scripts

echo "Archive created at $BASE_DIR/$ARCHIVE_FILE_NAME"

