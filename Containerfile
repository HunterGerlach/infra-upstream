# syntax=docker/dockerfile:1           ← Buildah ignores this line
###############################################################################
#  infra-upstream bootc derivative (Buildah-friendly)                          #
###############################################################################

ARG FLAVOR=bluefin                      # overridable in the workflow matrix
ARG FEDORA_TAG=stable

FROM ghcr.io/ublue-os/${FLAVOR}:${FEDORA_TAG}

# ───────────── image metadata ────────────────────────────────────────────────
LABEL org.opencontainers.image.title="huntergerlach/infra-upstream" \
      org.opencontainers.image.source="https://github.com/HunterGerlach/infra-upstream"

# ───────────── package layer ────────────────────────────────────────────────
# Buildah runs as root in CI, so we already have the caps rpm-ostree wants.
RUN --mount=type=cache,target=/var/cache/dnf \
    rpm-ostree install htop git && \
    rpm-ostree cleanup -m

# ───────────── configuration ────────────────────────────────────────────────
COPY etc/ /etc/

# ───────────── finalise bootc ───────────────────────────────────────────────
RUN bootc finalize

CMD ["/usr/bin/bash"]