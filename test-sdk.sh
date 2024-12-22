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

BUILDER_TAG=swift-builder:${SWIFT_VERSION}
echo "Building ${BUILDER_TAG} image to be used to compile test-project..."
docker build \
    --build-arg SWIFT_VERSION=${SWIFT_VERSION} \
    --build-arg USER=${USER} \
    --build-arg UID=${UID} \
    --tag ${BUILDER_TAG} \
    --file swift-builder.dockerfile \
    .

SDK_NAME=${SWIFT_VERSION}-RELEASE_${DISTRIBUTION_NAME}_${DISTRIBUTION_VERSION}_${TARGET_ARCH}
echo "Testing $SDK_NAME by building test-project..."
docker run --rm \
    --user ${USER} \
    --volume $(pwd):/src \
    --workdir /src \
    ${BUILDER_TAG} \
    /bin/bash -c "swift build \
        --package-path test-project \
        --target sswg-incubated-packages \
        --experimental-swift-sdks-path swift-sdk-generator/Bundles \
        --experimental-swift-sdk ${SDK_NAME} ${EXTRA_FLAGS}"
