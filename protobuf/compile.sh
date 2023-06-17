#!/bin/bash

WORK_DIR=$(dirname "$0")
cd "${WORK_DIR}"

TARGET_DIR="../lib/protobuf";

SRC_DIR="."
DST_DIR="../lib/protobuf"

if [ ! -e ${TARGET_DIR} ]  ;then
  mkdir ${TARGET_DIR}
else
  rm -rfv ${TARGET_DIR}
  mkdir ${TARGET_DIR}
fi

protoc -I=$SRC_DIR \
       --dart_out=$DST_DIR \
       ./MessageStructure.proto \
       /opt/protobuf/include/google/protobuf/timestamp.proto
