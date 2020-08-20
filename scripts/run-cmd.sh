#!/bin/bash

set -e

BASE_DIR=$PWD
CMD=$1
SCOPED_PKG=$2

if [[ -z ${SCOPED_PKG} ]]; then
  # run the given command on all packages
  for dir in ./packages/*; do
    cd $dir
    echo '==========='
    echo "Running command for $dir"
    echo '==========='
    $CMD
    cd $BASE_DIR
  done
else
  # if package scope is specfied, then cd into given package and execute command
  cd "./packages/$SCOPED_PKG" && $CMD
fi