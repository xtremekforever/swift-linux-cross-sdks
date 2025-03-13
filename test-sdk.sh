#!/bin/bash

set -e

TARGET_ARCH=${TARGET_ARCH:=x86_64}
TEST_PROJECT=${TEST_PROJECT:=test-project}
TEST_BINARY=${TEST_BINARY:=hello-world}
BUILD_PROFILE=${BUILD_PROFILE:=debug}

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

BUILDER_TAG=swift-builder:${SWIFT_VERSION}
echo "Building ${BUILDER_TAG} image to be used to compile test-project..."
docker build \
    --build-arg SWIFT_VERSION=${SWIFT_VERSION} \
    --build-arg USER=${USER} \
    --build-arg UID=${UID} \
    --tag ${BUILDER_TAG} \
    --file swift-builder.dockerfile \
    .

SWIFT_SDK_COMMAND="experimental-swift-sdk"
if [[ $SWIFT_VERSION == *"6."* ]]; then
    SWIFT_SDK_COMMAND="swift-sdk"
fi

SDK_NAME=${SWIFT_VERSION}-RELEASE_${DISTRIBUTION_NAME}_${DISTRIBUTION_VERSION}_${TARGET_ARCH}
PACKAGE_PATH="--package-path ${TEST_PROJECT}"
echo "Testing $SDK_NAME by building test-project with extra flags: ${EXTRA_FLAGS}"
swift package clean ${PACKAGE_PATH}
docker run --rm \
    --user ${USER} \
    --volume $(pwd):/src \
    --workdir /src \
    ${BUILDER_TAG} \
    /bin/bash -c "swift build \
        ${PACKAGE_PATH} \
        --${SWIFT_SDK_COMMAND}s-path swift-sdk-generator/Bundles \
        --${SWIFT_SDK_COMMAND} ${SDK_NAME} ${EXTRA_FLAGS}"

if [ $TEST_BINARY ]; then
    OUTPUT_BINARY=${TEST_PROJECT}/.build/${BUILD_PROFILE}/${TEST_BINARY}
    file $OUTPUT_BINARY
    du -hs $OUTPUT_BINARY
    echo "Required Libraries:"
    readelf -d $OUTPUT_BINARY | grep "Shared library:" | sed -n 's/.*\[\(.*\)\].*/- \1/p'
fi
