set -ex; \
[ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf; \
apk add --no-cache ca-certificates; \
apk add --no-cache \
    gcc \
    musl-dev; \
apk add --no-cache --virtual .fetch-deps gnupg; \
arch="$(apk --print-arch)"; \
url=; \
case "${arch}" in \
  'x86_64') \
    export GOAMD64='v1' GOARCH='amd64' GOOS='linux'; \
    ;; \
  'armhf') \
    export GOARCH='arm' GOARM='6' GOOS='linux'; \
    ;; \
  'armv7') \
    export GOARCH='arm' GOARM='7' GOOS='linux'; \
    ;; \
  'aarch64') \
    export GOARCH='arm64' GOOS='linux'; \
     ;; \
  'x86') \
    export GO386='softfloat' GOARCH='386' GOOS='linux'; \
    ;; \
  'ppc64le') \
    export GOARCH='ppc64le' GOOS='linux'; \
    ;; \
  's390x') \
    export GOARCH='s390x' GOOS='linux'; \
    ;; \
  *) \
    echo >&2 "error: unsupported architecture '${arch}' (likely packaging update needed)"; \
    exit 1 \
    ;; \
esac; \
build=; \
if [ -z "${url}" ]; then \
  build=1; \
  url="https://dl.google.com/go/go${GOLANG_VERSION}.src.tar.gz"; \
  case $(echo ${GOLANG_VERSION} | awk -F[\.] '{print $1"."$2}') in \
    '1.13') \
      sha256='5fb43171046cf8784325e67913d55f88a683435071eef8e9da1aa8a1588fcf5d'; \
      ;; \
    '1.14') \
      sha256='7ed13b2209e54a451835997f78035530b331c5b6943cdcd68a3d815fdc009149'; \
      ;; \
    '1.15') \
      sha256='0662ae3813330280d5f1a97a2ee23bbdbe3a5a7cfa6001b24a9873a19a0dc7ec'; \
      ;; \
    '1.16') \
      sha256='90a08c689279e35f3865ba510998c33a63255c36089b3ec206c912fc0568c3d3'; \
      ;; \
    '1.17') \
      sha256='a1a48b23afb206f95e7bbaa9b898d965f90826f6f1d1fc0c1d784ada0cd300fd'; \
      ;; \
    '1.18') \
      sha256='1f79802305015479e77d8c641530bc54ec994657d5c5271e0172eb7118346a12'; \
      ;; \
    '1.19') \
      sha256='eda74db4ac494800a3e66ee784e495bfbb9b8e535df924a8b01b1a8028b7f368'; \
      ;; \
  esac; \
fi; \
wget -O go.tgz.asc "${url}.asc"; \
wget -O go.tgz "${url}"; \
echo "${sha256} *go.tgz" | sha256sum -c - || exit 1; \
GNUPGHOME="$(mktemp -d)"; \
export GNUPGHOME; \
gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 'EB4C 1BFD 4F04 2F6D DDCC  EC91 7721 F63B D38B 4796'; \
gpg --batch --keyserver keyserver.ubuntu.com --recv-keys '2F52 8D36 D67B 69ED F998  D857 78BD 6547 3CB3 BD13'; \
gpg --batch --verify go.tgz.asc go.tgz; \
gpgconf --kill all; \
rm -rf "${GNUPGHOME}" go.tgz.asc; \
tar -C /usr/local -xzf go.tgz; \
rm go.tgz; \
if [ -n "${build}" ]; then \
  apk add --no-cache --virtual .build-deps \
      bash \
      gcc \
      go \
      musl-dev; \
  export GOCACHE='/tmp/gocache'; \
  (cd /usr/local/go/src; export GOROOT_BOOTSTRAP="$(go env GOROOT)" GOHOSTOS="${GOOS}" GOHOSTARCH="${GOARCH}"; ./make.bash;); \
  apk del --no-network .build-deps; \
  rm -rf /usr/local/go/pkg/*/cmd \
      /usr/local/go/pkg/bootstrap \
      /usr/local/go/pkg/obj \
      /usr/local/go/pkg/tool/*/api \
      /usr/local/go/pkg/tool/*/go_bootstrap \
      /usr/local/go/src/cmd/dist/dist \
      "${GOCACHE}"; \
fi; \
apk del --no-network .fetch-deps; \
go version || exit 1; \
mkdir -p "${GOPATH}/src" "${GOPATH}/bin"; \
chmod -R 777 "${GOPATH}"; \
rm -f install_golang_alpine.sh

