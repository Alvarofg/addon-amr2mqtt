# hadolint global ignore=DL3008
# ignoring DL3008 (pin versions) as we are using the official images
ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base/amd64:9.2.0

# https://hub.docker.com/_/golang
FROM golang:1.25.6-alpine3.23 AS build_rtlamr
# https://github.com/bemasher/rtlamr/releases
ENV RTLAMR_VERSION=0.9.4
ENV GOBIN=/usr/bin
RUN set -eux; \
    go install "github.com/bemasher/rtlamr@v${RTLAMR_VERSION}"; \
    rtlamr --version


# https://github.com/hassio-addons/addon-debian-base/releases
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

RUN set -eux; \
    apt-get update; \
    apt-get install -qy --no-install-recommends \
        ca-certificates \
        librtlsdr-dev \
        python3-paho-mqtt \
        python3-dateutil \
        rtl-sdr \
        ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    \
    echo "Add user for AMR2MQTT"; \
    mkdir -p /data/amr2mqtt; \
    useradd -u 12345 -U -d /data/amr2mqtt abc;

# Add rtlamr
COPY --from=build_rtlamr /usr/bin/rtlamr /usr/bin/rtlamr
RUN rtlamr --version

COPY --chown=abc:abc rootfs /
WORKDIR /data/amr2mqtt

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Set name & version as env for use in scripts
ENV BUILD_VERSION=${BUILD_VERSION}
ENV BUILD_NAME=${BUILD_NAME}

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Alvarofg" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="mdegat01's Home Assistant Add-ons" \
    org.opencontainers.image.authors="mdegat01" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/mdegat01/hassio-addons" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION} \
