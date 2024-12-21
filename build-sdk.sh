#!/bin/bash

TARGET_ARCH=${TARGET_ARCH:=x86_64}

SWIFT_VERSION=$1
if [ -z $SWIFT_VERSION ]; then
    echo "Swift version is required! (e.g.: 6.0.3)"
    exit -1
fi

DISTRIBUTION_NAME=$2
if [ -z $DISTRIBUTION_NAME ]; then 
    echo "Distribution name is required! (e.g.: ubuntu, rhel)"
    exit -1
fi

DISTRIBUTION_VERSION=$3
if [ -z $DISTRIBUTION_VERSION ]; then
    echo "Distribution version is required! (e.g.: jammy, bookworm)"
    exit -1
fi

IMAGE_TAG=${IMAGE_TAG:=swift-sysroot:${SWIFT_VERSION}-${DISTRIBUTION_VERSION}}

case ${TARGET_ARCH} in
    "x86_64")
        DOCKER_PLATFORM=linux/amd64
        ;;
    "aarch64")
        DOCKER_PLATFORM=linux/arm64
        ;;
    "armv7")
        DOCKER_PLATFORM=linux/arm/v7
        ;;
    *)
        echo "Unsupported architecture ${TARGET_ARCH}"
        exit -1
        ;;
esac

DOCKERFILE="swift-official.dockerfile"
case ${DISTRIBUTION_VERSION} in
    "focal")
        GENERATOR_DISTRIBUTION_VERSION=20.04
        ;;
    "jammy")
        GENERATOR_DISTRIBUTION_VERSION=22.04
        ;;
    *)
        DOCKERFILE="swift-unofficial.dockerfile"
        GENERATOR_DISTRIBUTION_VERSION=${DISTRIBUTION_VERSION}
esac

echo "Building ${IMAGE_TAG} image for ${DOCKER_PLATFORM}..."
echo "Extra Packages: ${EXTRA_PACKAGES}"
docker build \
    --platform ${DOCKER_PLATFORM} \
    --tag ${IMAGE_TAG} \
    --build-arg SWIFT_VERSION=${SWIFT_VERSION} \
    --build-arg DISTRIBUTION_VERSION=${DISTRIBUTION_VERSION} \
    --build-arg EXTRA_PACKAGES=${EXTRA_PACKAGES} \
    --file ${DOCKERFILE} \
    .

echo "Building Swift ${SWIFT_VERSION} ${DISTRIBUTION_NAME}-${GENERATOR_DISTRIBUTION_VERSION} SDK for ${TARGET_ARCH}..."
swift-sdk-generator make-linux-sdk \
          --swift-version ${SWIFT_VERSION}-RELEASE \
          --with-docker \
          --from-container-image ${IMAGE_TAG} \
          --linux-distribution-name ${DISTRIBUTION_NAME} \
          --linux-distribution-version ${GENERATOR_DISTRIBUTION_VERSION} \
          --target ${TARGET_ARCH}-unknown-linux-gnu \
          --no-host-toolchain
