#!/bin/bash

PLATFORM=${PLATFORM:=linux/amd64}

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

case $DISTRIBUTION in
    "focal" | "jammy" | "bookworm")
        DOCKERFILE="swift-official.dockerfile"
        ;;
    *)
        echo "Unsupported distribution ${DISTRIBUTION}!"
        exit
        ;;
esac

IMAGE_TAG=${IMAGE_TAG:=swift-sysroot:${SWIFT_VERSION}-${DISTRIBUTION}}

echo "Building Swift ${SWIFT_VERSION}-${DISTRIBUTION} image for ${PLATFORM}..."
echo "Extra Packages: ${EXTRA_PACKAGES}"
docker build \
    --platform ${PLATFORM} \
    --tag ${IMAGE_TAG} \
    --build-arg SWIFT_VERSION=${SWIFT_VERSION} \
    --build-arg DISTRIBUTION=${DISTRIBUTION} \
    --build-arg EXTRA_PACKAGES=${EXTRA_PACKAGES} \
    --file ${DOCKERFILE} \
    .
