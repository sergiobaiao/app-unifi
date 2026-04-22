ARG BUILD_FROM=ghcr.io/lemker/unifi-os-server:latest
# Use the UniFi OS Server image from lemker (always latest)
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy local rootfs
COPY rootfs /

# Set workdir
WORKDIR /root

# Download the UOS entrypoint script from lemker repository
RUN curl -fsSL https://raw.githubusercontent.com/lemker/unifi-os-server/main/uos-entrypoint.sh \
    -o /root/uos-entrypoint.sh \
    && chmod +x /root/uos-entrypoint.sh

# Set STOPSIGNAL for systemd
STOPSIGNAL SIGRTMIN+3

# Health check
HEALTHCHECK --start-period=5m \
    CMD curl --insecure --fail https://localhost:11443 || exit 1

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="app" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <opensource@frenck.dev>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Apps" \
    org.opencontainers.image.authors="Franck Nijhof <opensource@frenck.dev>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://frenck.dev/home-assistant-apps" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

# Use our custom Home Assistant entrypoint
ENTRYPOINT ["/usr/local/bin/ha-entrypoint.sh"]
