ARG SWIFT_VERSION=6.0.3
ARG DISTRIBUTION=jammy
FROM swift:${SWIFT_VERSION}-${DISTRIBUTION}
ARG EXTRA_PACKAGES
RUN apt update && apt -y install libsystemd-dev ${EXTRA_PACKAGES} && apt -y clean
