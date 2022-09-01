set -ex; \
apk add --no-cache \
    ca-certificates \
    gcc \
    libc-dev \
    wget; \
apkArch="$(apk --print-arch)"; \
case "${apkArch}" in
  x86_64) \
  rustArch='x86_64-unknown-linux-musl'; \
  case ${RUST_VERSION} in
    '1.63.0') \
      rustupSha256='95427cb0592e32ed39c8bd522fe2a40a746ba07afb8149f91e936cddb4d6eeac'; \
      ;; \
  esac; \
  ;; \
*) \
  echo >&2 "unsupported architecture: ${apkArch}"; \
  exit 1; \
  ;; \
esac; \
url="https://static.rust-lang.org/rustup/archive/1.25.1/${rustArch}/rustup-init"; \
wget "${url}"; \
echo "${rustupSha256}  rustup-init" | sha256sum -c - || exit 1; \
chmod +x rustup-init; \
mkdir -p /opt/rust/.cargo; \
./rustup-init -y --no-modify-path --profile minimal --default-toolchain ${RUST_VERSION} --default-host ${rustArch}; \
rm rustup-init; \
rustup --version || exit 1; \
cargo --version || exit 1; \
rustc --version || exit 1; \
apk del --no-cache --no-network \
    wget; \
rm -f install_rust_alpine.sh

