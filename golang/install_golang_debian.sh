set -ex; \
apt-get update -y; \
apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    netbase; \
if ! command -v gpg > /dev/null; then \
  apt-get install -y --no-install-recommends \
      gnupg \
      dirmngr; \
fi; \
apt-get install -y --no-install-recommends \
    git \
    mercurial \
    openssh-client \
    subversion \
    procps; \
apt-get install -y --no-install-recommends \
    g++ \
    gcc \
    libc6-dev \
    make \
    pkg-config; \
arch="$(dpkg --print-architecture)"; \
arch="${arch##*-}"; \
url=; \
case "${arch}" in \
  'amd64') \
    url="https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz"; \
    case $(echo ${GOLANG_VERSION} | awk -F[\.] '{print $1"."$2}') in \
      '1.13') \
        sha256='01cc3ddf6273900eba3e2bf311238828b7168b822bb57a9ccab4d7aa2acd6028'; \
        ;; \
      '1.14') \
        sha256='c64a57b374a81f7cf1408d2c410a28c6f142414f1ffa9d1062de1d653b0ae0d6'; \
        ;; \
      '1.15') \
        sha256='0885cf046a9f099e260d98d9ec5d19ea9328f34c8dc4956e1d3cd87daaddb345'; \
        ;; \
      '1.16') \
        sha256='77c782a633186d78c384f972fb113a43c24be0234c42fef22c2d8c4c4c8e7475'; \
        ;; \
      '1.17') \
        sha256='4cdd2bc664724dc7db94ad51b503512c5ae7220951cac568120f64f8e94399fc'; \
        ;; \
      '1.18') \
        sha256='9e5de37f9c49942c601b191ac5fba404b868bfc21d446d6960acc12283d6e5f2'; \
        ;; \
      '1.19') \
        sha256='74b9640724fd4e6bb0ed2a1bc44ae813a03f1e72a4c76253e2d5c015494430ba'; \
        ;; \
    esac; \
    ;; \
  *) \
    echo >&2 "error: unsupported architecture '$arch' (likely packaging update needed)"; \
    exit 1; \
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
      sha256='9920d3306a1ac536cdd2c796d6cb3c54bc559c226fc3cc39c32f1e0bd7f50d2a'; \
      ;; \
    '1.19') \
      sha256='18ac263e39210bcf68d85f4370e97fb1734166995a1f63fb38b4f6e07d90d212'; \
      ;; \
  esac; \
  echo >&2; \
  echo >&2 "warning: current architecture (${arch}) does not have a compatible Go binary release; will be building from source"; \
  echo >&2; \
fi; \
curl -Lo go.tgz.asc "${url}.asc"; \
curl -Lo go.tgz "${url}"; \
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
  savedAptMark="$(apt-mark showmanual)"; \
  apt-get update; \
  apt-get install -y --no-install-recommends golang-go; \
  export GOCACHE='/tmp/gocache'; \
  (cd /usr/local/go/src; export GOROOT_BOOTSTRAP="$(go env GOROOT)" GOHOSTOS="${GOOS}" GOHOSTARCH="${GOARCH}"; ./make.bash;); \
  apt-mark auto '.*' > /dev/null; \
  apt-mark manual ${savedAptMark} > /dev/null; \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
  rm -rf /var/lib/apt/lists/*; \
  rm -rf /usr/local/go/pkg/*/cmd \
      /usr/local/go/pkg/bootstrap \
      /usr/local/go/pkg/obj \
      /usr/local/go/pkg/tool/*/api \
      /usr/local/go/pkg/tool/*/go_bootstrap \
      /usr/local/go/src/cmd/dist/dist \
      "${GOCACHE}"; \
fi; \
go version || exit 1; \
mkdir -p "${GOPATH}/src" "${GOPATH}/bin"; \
chmod -R 777 "${GOPATH}"; \
rm -f install_golang_debian.sh

