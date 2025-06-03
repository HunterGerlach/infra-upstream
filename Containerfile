# syntax=docker/dockerfile:1.7-labs
###############################################################################
#  infra-upstream bootc derivative                                            #
###############################################################################

###############################################################################
# ───────────── build-time arguments ───────────────────────────────────────── #
###############################################################################
ARG FLAVOR=bluefin              # default when building locally
ARG FEDORA_TAG=stable           # default; overridden by CI matrix

###############################################################################
# ───────────── base image ─────────────────────────────────────────────────── #
###############################################################################
FROM ghcr.io/ublue-os/${FLAVOR}:${FEDORA_TAG}

###############################################################################
# ───────────── image metadata ─────────────────────────────────────────────── #
###############################################################################
LABEL org.opencontainers.image.title="huntergerlach/infra-upstream" \
      org.opencontainers.image.source="https://github.com/HunterGerlach/infra-upstream"

###############################################################################
# ───────────── package layer ──────────────────────────────────────────────── #
#  ⚠ rpm-ostree needs elevated caps; on GitHub runners this is blocked.       #
#    Long-term we’ll switch to a dnf-based stage + `bootc commit`.            #
###############################################################################
RUN --mount=type=cache,target=/var/cache/dnf \
    rpm-ostree install \
        htop \
        git \
    && rpm-ostree cleanup -m

###############################################################################
# ───────────── optional configuration copy ───────────────────────────────── #
#  The step below never fails:                                                #
#   • if `etc/` is entirely absent → build continues                          #
#   • if `etc/` exists but is empty        → build continues                  #
###############################################################################
# 1. Always create an empty scratch dir so COPY never 404s
RUN mkdir -p /tmp/ctx-empty
# 2. Copy *whatever* shows up under etc/ into /tmp/etc  (if nothing, dir empty)
COPY ["etc/", "/tmp/etc/"]

# 3. Move only when the directory contains real files
RUN if [ -d /tmp/etc ] && [ "$(ls -A /tmp/etc)" ]; then \
        echo "› Installing drop-in config from build context" && \
        cp -a /tmp/etc/* /etc/ ; \
    else \
        echo "› No custom config found – skipping"; \
    fi && \
    rm -rf /tmp/etc

###############################################################################
# ───────────── finalise bootc ─────────────────────────────────────────────── #
###############################################################################
RUN bootc finalize

###############################################################################
# ───────────── runtime ────────────────────────────────────────────────────── #
###############################################################################
CMD ["/usr/bin/bash"]