###############################################################################
# Build-arg-driven universal-blue bootc image.
#   FLAVOR=core    -> quay.io/ublue-os/core:<FEDORA_VERSION>
#   FLAVOR=bluefin -> quay.io/ublue-os/bluefin:<FEDORA_VERSION>
###############################################################################
ARG FLAVOR=core
ARG FEDORA_VERSION=40

FROM quay.io/ublue-os/${FLAVOR}:${FEDORA_VERSION}

LABEL maintainer="Your Name <you@example.com>"
LABEL org.opencontainers.image.description="Home-lab ${FLAVOR} bootc image"
LABEL org.opencontainers.image.vendor="Home Lab"
LABEL org.opencontainers.image.title="ublue-${FLAVOR}"
LABEL org.opencontainers.image.url="https://github.com/${GITHUB_REPOSITORY}"
LABEL org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}"

############################
# Layer RPM-OSTree packages
############################
# --privileged required by rpm-ostree in container build
RUN --privileged --mount=type=cache,target=/var/cache/dnf \
    rpm-ostree install \
        htop git \
    && rpm-ostree cleanup -m

############################
# Optional: copy config, dotfiles, etc.
############################
# COPY ./etc /etc

############################
# Finalize
############################
RUN echo "Custom build complete for ${FLAVOR}" > /etc/ublue-custom.txt

CMD [ "/usr/lib/systemd/systemd" ]