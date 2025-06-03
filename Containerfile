# syntax=docker/dockerfile:1.7-labs
###############################################################################
#  infra-upstream bootc derivative                                            #
###############################################################################

ARG FLAVOR=bluefin
ARG FEDORA_TAG=stable

FROM ghcr.io/ublue-os/${FLAVOR}:${FEDORA_TAG}

LABEL org.opencontainers.image.title="huntergerlach/infra-upstream" \
      org.opencontainers.image.source="https://github.com/HunterGerlach/infra-upstream"

# ── extra user-space packages ───────────────────────────────────────────────
RUN --mount=type=cache,target=/var/cache/dnf \
    rpm-ostree install \
        htop \
        git  \
        fastfetch \
    && rpm-ostree cleanup -m

CMD ["/usr/bin/bash"]