#!/bin/sh

set -e

BASE_DIR="$( cd "$( dirname "$0" )" && pwd )"
VERSION=$(cat $BASE_DIR/VERSION)
ARCHIVE_FILE_NAME=mesos-dev-$VERSION.tar.gz

echo "Building standalone distribution archive for version: $VERSION"

pushd $BASE_DIR > /dev/null
tar zcf $ARCHIVE_FILE_NAME scripts
popd > /dev/null

echo "Archive created at $BASE_DIR/$ARCHIVE_FILE_NAME"

