# syntax=docker/dockerfile:1.7-labs
###############################################################################
#  infra-upstream bootc derivative                                             #
#  ─────────────────────────────────────────────────────────────────────────── #
#  This builds a custom image on top of an official uBlue flavour.            #
#  The GitHub Actions workflow supplies two build-args:                       #
#     • FLAVOR       (e.g. bluefin | core | ucore …)                          #
#     • FEDORA_TAG   (e.g. stable | testing | rawhide)                        #
###############################################################################

ARG FLAVOR=bluefin                      # default for local builds
ARG FEDORA_TAG=stable                   # default; overridden in CI matrix

FROM ghcr.io/ublue-os/${FLAVOR}:${FEDORA_TAG}

###############################################################################
#  image metadata                                                              #
###############################################################################
LABEL org.opencontainers.image.title="huntergerlach/infra-upstream" \
      org.opencontainers.image.source="https://github.com/HunterGerlach/infra-upstream"

###############################################################################
#  package layer                                                               #
#                                                                             #
#  ⚠️  rpm-ostree needs elevated capabilities inside BuildKit.                #
#      Locally we can grant them; on GitHub runners we can’t (                  #
#      security.insecure is blocked). A future change will                     #
#      swap this out for a root-ful DNF stage + `bootc commit`.                #
###############################################################################
RUN --security=insecure --mount=type=cache,target=/var/cache/dnf \
    rpm-ostree install \
        htop \
        git \
    && rpm-ostree cleanup -m

###############################################################################
#  configuration                                                               #
###############################################################################
# Copy any drop-in configuration (systemd units, default configs, etc.)
COPY --link \
    etc/ /etc/

###############################################################################
#  finalise bootc                                                              #
###############################################################################
RUN bootc finalize

###############################################################################
#  runtime                                                                     #
###############################################################################
CMD ["/usr/bin/bash"]