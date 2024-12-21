#!/bin/bash

TARGET_ARCH=${TARGET_ARCH:=x86_64}

SWIFT_VERSION=$1
SWIFT_VERSION=$(echo $SWIFT_VERSION | xargs)
if [ -z $SWIFT_VERSION ]; then
    echo "Swift version is required! (e.g.: 6.0.3)"
    exit -1
fi

DISTRIBUTION_NAME=$2
DISTRIBUTION_NAME=$(echo $DISTRIBUTION_NAME | xargs)
if [ -z $DISTRIBUTION_NAME ]; then 
    echo "Distribution name is required! (e.g.: ubuntu, rhel)"
    exit -1
fi

DISTRIBUTION_VERSION=$3
DISTRIBUTION_VERSION=$(echo $DISTRIBUTION_VERSION | xargs)
if [ -z $DISTRIBUTION_VERSION ]; then
    echo "Distribution version is required! (e.g.: jammy, bookworm)"
    exit -1
fi

SDK_NAME=${SWIFT_VERSION}-RELEASE_${DISTRIBUTION_NAME}_${DISTRIBUTION_VERSION}_${TARGET_ARCH}
echo "Testing $SDK_NAME by building test-project..."
swift build \
    --package-path test-project \
    --swift-sdks-path swift-sdk-generator/Bundles \
    --swift-sdk $SDK_NAME
