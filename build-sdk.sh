#!/bin/bash

set -e

TARGET_ARCH=${TARGET_ARCH:=x86_64}

SDK_GENERATOR_PATH=./swift-sdk-generator/.build/release/swift-sdk-generator

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

IMAGE_TAG=${IMAGE_TAG:=swift-sysroot:${SWIFT_VERSION}-${DISTRIBUTION_VERSION}}

DOCKERFILE="swift-official.dockerfile"
case ${TARGET_ARCH} in
    "x86_64")
        LINUX_PLATFORM=amd64
        TARGET_TRIPLE=${TARGET_ARCH}-unknown-linux-gnu
        ;;
    "aarch64")
        LINUX_PLATFORM=arm64
        TARGET_TRIPLE=${TARGET_ARCH}-unknown-linux-gnu
        ;;
    "armv7")
        LINUX_PLATFORM=armhf
        DOCKERFILE="swift-armv7.dockerfile"
        TARGET_TRIPLE=${TARGET_ARCH}-unknown-linux-gnueabihf
        ;;
    *)
        echo "Unsupported architecture ${TARGET_ARCH}"
        exit -1
        ;;
esac

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

echo "Starting up qemu emulation"
docker run --privileged --rm tonistiigi/binfmt --install all

echo "Building ${IMAGE_TAG} image for ${LINUX_PLATFORM}..."
echo "Extra Packages: ${EXTRA_PACKAGES}"
docker build \
    --platform linux/${LINUX_PLATFORM} \
    --tag ${IMAGE_TAG} \
    --build-arg SWIFT_VERSION=${SWIFT_VERSION} \
    --build-arg DISTRIBUTION_NAME=${DISTRIBUTION_NAME} \
    --build-arg DISTRIBUTION_VERSION=${DISTRIBUTION_VERSION} \
    --build-arg EXTRA_PACKAGES=${EXTRA_PACKAGES} \
    --file ${DOCKERFILE} \
    .

echo "Building Swift ${SWIFT_VERSION} ${DISTRIBUTION_NAME}-${GENERATOR_DISTRIBUTION_VERSION} SDK for ${TARGET_ARCH}..."
${SDK_GENERATOR_PATH} make-linux-sdk \
          --swift-version ${SWIFT_VERSION}-RELEASE \
          --with-docker \
          --from-container-image ${IMAGE_TAG} \
          --linux-distribution-name ${DISTRIBUTION_NAME} \
          --linux-distribution-version ${GENERATOR_DISTRIBUTION_VERSION} \
          --target ${TARGET_TRIPLE} \
          --no-host-toolchain

# Determine some paths
SDK_NAME=${SWIFT_VERSION}-RELEASE_${DISTRIBUTION_NAME}_${DISTRIBUTION_VERSION}_${TARGET_ARCH}
BUNDLES_DIR=swift-sdk-generator/Bundles
SDK_DIR=$SDK_NAME.artifactbundle
SDK_SYSROOT_DIR=$SDK_DIR/$SDK_NAME/$TARGET_TRIPLE/${DISTRIBUTION_NAME}-${DISTRIBUTION_VERSION}.sdk

# Build package
case ${DISTRIBUTION_NAME} in
    "ubuntu")
        SWIFT_VERSION=${SWIFT_VERSION} \
        DISTRIBUTION_NAME=${DISTRIBUTION_NAME} \
        DISTRIBUTION_VERSION=${DISTRIBUTION_VERSION} \
        LINUX_PLATFORM=${LINUX_PLATFORM} \
        SDK_SYSROOT_PATH=${BUNDLES_DIR}/${SDK_SYSROOT_DIR} \
        ./build-deb.sh
        ;;
esac

# Compress SDK as the final step
cd $BUNDLES_DIR
echo "Compressing SDK into artifacts/$SDK_DIR.tar.gz archive..."
tar -czf $SDK_DIR.tar.gz $SDK_DIR
