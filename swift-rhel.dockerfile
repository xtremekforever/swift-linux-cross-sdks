ARG SWIFT_VERSION=6.0.3
ARG DISTRIBUTION_NAME=rhel
ARG DISTRIBUTION_VERSION=ubi9
FROM swift:${SWIFT_VERSION}-${DISTRIBUTION_NAME}-${DISTRIBUTION_VERSION}
ARG EXTRA_PACKAGES
RUN dnf -y install systemd-devel ${EXTRA_PACKAGES} && dnf clean all
