ARG DISTRIBUTION_NAME=ubuntu
ARG DISTRIBUTION_VERSION=jammy
FROM ${DISTRIBUTION_NAME}:${DISTRIBUTION_VERSION}

ARG EXTRA_PACKAGES
RUN apt update && apt -y install wget clang libsystemd-dev zlib1g-dev libcurl4-openssl-dev ${EXTRA_PACKAGES} && apt -y clean

ARG SWIFT_VERSION
ARG DISTRIBUTION_NAME=ubuntu
ARG DISTRIBUTION_VERSION=jammy
ARG ROOT_URL=https://github.com/xtremekforever/swift-armv7/releases/download
ARG PACKAGE_NAME=swift-${SWIFT_VERSION}-RELEASE-${DISTRIBUTION_NAME}-${DISTRIBUTION_VERSION}-armv7-install.tar.gz
RUN wget ${ROOT_URL}/${SWIFT_VERSION}/${PACKAGE_NAME} && tar -xf ${PACKAGE_NAME} -C / && rm ${PACKAGE_NAME}
