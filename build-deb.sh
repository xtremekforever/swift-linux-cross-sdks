#!/bin/bash

echo "Creating deb artifact of the Swift ${SWIFT_VERSION} runtime for ${LINUX_PLATFORM}..."

# Create directories
PACKAGE_NAME=swift-runtime_${SWIFT_VERSION}-${DISTRIBUTION_NAME}-${DISTRIBUTION_VERSION}_${LINUX_PLATFORM}
ARTIFACT_PATH=artifacts/${PACKAGE_NAME}
mkdir -p ${ARTIFACT_PATH}/DEBIAN
mkdir -p ${ARTIFACT_PATH}/usr/lib/swift/linux

# Copy files
cp -r ${SDK_SYSROOT_PATH}/usr/lib/swift/linux/*.so ${ARTIFACT_PATH}/usr/lib/swift/linux

# Strip files
$STRIP_BINARY -s ${ARTIFACT_PATH}/usr/lib/swift/linux/*.so

# Create control file
cat <<EOT > ${ARTIFACT_PATH}/DEBIAN/control
Package: swift-runtime
Version: ${SWIFT_VERSION}
Maintainer: Jesse L. Zamora <xtremekforever@gmail.com>
Depends: libcurl4, libedit2, libxml2, zlib1g
Architecture: ${LINUX_PLATFORM}
Description: Swift Runtime ${SWIFT_VERSION}
EOT

# Build package
cd artifacts
dpkg-deb --build ${PACKAGE_NAME}
