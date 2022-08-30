set -ex; \
apk add --no-cache \
  ca-certificates \
  curl; \
apk add --no-cache \
  gcc; \
mkdir -p /opt/rust; \
curl -Lo rustup.sh https://sh.rustup.rs; \
/bin/sh rustup.sh --default-toolchain stable -y; \
rm -f rustup.sh; \
rm -f install_rust_alpine.sh

