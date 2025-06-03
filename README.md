# infra-upstream

![CI](https://github.com/HunterGerlach/infra-upstream/actions/workflows/build-bootc.yml/badge.svg)

bootc Images

This repo builds two Fedora-based **bootable containers** using Universal Blue:

| Tag | Base image |
|-----|------------|
| `core-*`    | `quay.io/ublue-os/core:40` |
| `bluefin-*` | `quay.io/ublue-os/bluefin:40` |

## Build / publish

Pushing to **main** (or running *“Run workflow”* manually) triggers GitHub Actions:

1. Matrix builds for `core` and `bluefin`.
2. Tags are pushed to **ghcr.io**:
   * `ghcr.io/<owner>/<repo>:core-latest`
   * `ghcr.io/<owner>/<repo>:bluefin-latest`

Update `Containerfile` to add packages or config, commit, and push—images rebuild automatically.

## Install on target

```bash
sudo bootc install ghcr.io/<owner>/<repo>:core-latest