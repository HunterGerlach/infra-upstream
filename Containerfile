# syntax=docker/dockerfile:1.7-labs   # enables --security / --mount / --privileged

###############################################################################
# Build-arg-driven bootc image based on Universal Blue.
#   FLAVOR=core    → quay.io/ublue-os/core:<FEDORA_VERSION>
#   FLAVOR=bluefin → quay.io/ublue-os/bluefin:<FEDORA_VERSION>
###############################################################################
ARG FLAVOR=core
ARG FEDORA_VERSION=40

FROM quay.io/ublue-os/${FLAVOR}:${FEDORA_VERSION}

# ───────────── metadata ───────────────────────────────────────────────────────
LABEL maintainer="Your Name <you@example.com>"
LABEL org.opencontainers.image.vendor="Home Lab"
LABEL org.opencontainers.image.title="ublue-${FLAVOR}"
LABEL org.opencontainers.image.description="Home-lab bootc image (${FLAVOR})"
LABEL org.opencontainers.image.url="https://github.com/${GITHUB_REPOSITORY}"
LABEL org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}"

# ───────────── rpm-ostree layer ───────────────────────────────────────────────
# BuildKit’s labs channel lets us run rpm-ostree with elevated caps inside
# the build container.
RUN --security=insecure --mount=type=cache,target=/var/cache/dnf \
    rpm-ostree install \
        htop git \
    && rpm-ostree cleanup -m

# ───────────── optional configs ───────────────────────────────────────────────
# COPY ./etc /etc

RUN echo "Custom build complete for ${FLAVOR}" > /etc/ublue-custom.txt

# Default bootc entrypoint
CMD ["/usr/lib/systemd/systemd"]