#!/bin/bash

TARGET=${TARGET:=x86_64-unknown-linux-gnu}

SWIFT_VERSION=$1
if [ -z $SWIFT_VERSION ]; then
    echo "Swift version is required! (e.g.: 6.0.3)"
    exit -1
fi

DISTRIBUTION=$2
if [ -z $DISTRIBUTION ]; then 
    echo "Distribution is required! (e.g.: jammy)"
    exit -1
fi

IMAGE_TAG=${IMAGE_TAG:=swift-sysroot:${SWIFT_VERSION}-${DISTRIBUTION}}

echo "Building Swift ${SWIFT_VERSION}:${DISTRIBUTION} SDK for ${TARGET}..."
swift-sdk-generator make-linux-sdk \
          --swift-version ${SWIFT_VERSION}-RELEASE \
          --with-docker \
          --from-container-image ${IMAGE_TAG} \
          --target ${TARGET} \
          --no-host-toolchain
