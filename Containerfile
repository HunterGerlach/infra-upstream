# syntax=docker/dockerfile:1.7-labs

#── runtime build args injected by the workflow ───────────────────────────────
ARG FLAVOR=bluefin          # bluefin (desktop) or ucore (server)
ARG FEDORA_TAG=stable       # stable ▸ latest tested tag for the flavor

#── base image ────────────────────────────────────────────────────────────────
FROM ghcr.io/ublue-os/${FLAVOR}:${FEDORA_TAG}

#── image metadata ────────────────────────────────────────────────────────────
LABEL org.opencontainers.image.title="infra-upstream (${FLAVOR})"
LABEL org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}"

#── package layering (needs BuildKit labs) ────────────────────────────────────
RUN --security=insecure --mount=type=cache,target=/var/cache/dnf \
    rpm-ostree install htop git \
 && rpm-ostree cleanup -m

#── any extra files / tweaks here ─────────────────────────────────────────────
# COPY etc /usr/etc               # example

CMD ["/usr/lib/systemd/systemd"]