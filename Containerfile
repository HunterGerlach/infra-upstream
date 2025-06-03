# syntax=docker/dockerfile:1.7-labs
###############################################################################
#  Universal Blue-style bootc image, suitable for GitHub Actions builds
#
#  ─ Key points ───────────────────────────────────────────────────────────────
#  • No classical `--privileged` flag (that trips Dockerfile v1.7 parser)
#  • Uses BuildKit “insecure” entitlement for rpm-ostree layer operations
#    → make sure the workflow passes `--allow security.insecure`
#  • Package additions go through rpm-ostree, preserving bootc semantics
###############################################################################

########## build-time arguments ################################################
ARG FLAVOR="bluefin"          # bluefin|core|ucore … anything from ublue-os
ARG FEDORA_TAG="stable"       # stable|testing|rawhide etc.

########## base image ##########################################################
FROM ghcr.io/ublue-os/${FLAVOR}:${FEDORA_TAG}

########## image metadata ######################################################
# labels recognised by container registries & cosign attestations
LABEL org.opencontainers.image.title="${FLAVOR}-derived infra image" \
      org.opencontainers.image.description="Custom infra-upstream bootc image based on uBlue ${FLAVOR}" \
      org.opencontainers.image.vendor="Hunter Gerlach" \
      org.opencontainers.image.source="https://github.com/HunterGerlach/infra-upstream" \
      org.opencontainers.image.authors="huntergerlach" \
      org.opencontainers.image.licenses="MIT"

########## rpm-ostree customisation ############################################
# rpm-ostree needs elevated caps; BuildKit’s `security=insecure`
# is enough **as long as** the runner passes:  --allow security.insecure
# NB: no `--privileged` flag (that was what broke parsing earlier).
RUN --security=insecure \
    --mount=type=cache,target=/var/cache/dnf \
    rpm-ostree install \
        htop \
        git \
        # add more CLI tools here as needed \
    && rpm-ostree cleanup -m

########## clean up builder caches ############################################
RUN --mount=type=cache,target=/var/cache/dnf rm -rf /var/cache/dnf/*

########## bootc labels & finalisation #########################################
LABEL com.github.actions.name="Infra-upstream bootc (${FLAVOR})"
ENTRYPOINT [ "/usr/lib/bootc/bin/bootc", "install" ]
CMD [ "bash" ]