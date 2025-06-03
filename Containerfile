# syntax=docker/dockerfile:1.7-labs   # unlocks --security / --mount flags

###############################################################################
# Universal Blue bootc image for home-lab machines
#
#   FLAVOR=core    → ghcr.io/ublue-os/core:<FEDORA_VERSION>
#   FLAVOR=bluefin → ghcr.io/ublue-os/bluefin:<FEDORA_VERSION>
###############################################################################
ARG FLAVOR=core
ARG FEDORA_VERSION=40   # overridden per-flavour from the workflow matrix

FROM ghcr.io/ublue-os/${FLAVOR}:${FEDORA_VERSION}

# ───────────── image metadata ────────────────────────────────────────────────
LABEL maintainer="Your Name <you@example.com>"
LABEL org.opencontainers.image.vendor="Home Lab"
LABEL org.opencontainers.image.title="ublue-${FLAVOR}"
LABEL org.opencontainers.image.description="Custom bootc image for ${FLAVOR}"
LABEL org.opencontainers.image.url="https://github.com/${GITHUB_REPOSITORY}"
LABEL org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}"

# ───────────── rpm-ostree layer ──────────────────────────────────────────────
RUN --security=insecure --mount=type=cache,target=/var/cache/dnf \
    rpm-ostree install htop git \
 && rpm-ostree cleanup -m

# ───────────── optional configs ──────────────────────────────────────────────
# COPY ./etc /etc

RUN echo "Custom build complete for ${FLAVOR}" > /etc/ublue-custom.txt

# Default bootc entrypoint
CMD ["/usr/lib/systemd/systemd"]