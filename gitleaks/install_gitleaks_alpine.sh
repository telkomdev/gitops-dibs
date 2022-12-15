set -ex; \
adduser -u 1001 -D gitleaks; \
apk add --no-cache \
    curl \
    ca-certificates \
    tar; \
apk add --no-cache \
    bash \
    git \
    openssh-client; \
alpineArch="$(apk --print-arch)"; \
case "${alpineArch##*-}" in \
  x86_64) \
    SOURCE="https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"; \
    case $(echo ${GITLEAKS_VERSION} | awk -F[\.] '{print $1"."$2}') in \
      '8.11') \
        CHECKSUM="6f7c60f4b8194c0d8d860dd7af65361d4dc52b2df1aafd03287ea3446a75e9cd"; \
        ;; \
      '8.15') \
        CHECKSUM="43e007867e49376fac8953fc1be3ba540b4cefacec40ee9d4b465a9fb9ae3b8d"; \
        ;; \
    esac; \
    ;; \
  *) \
    ;; \
esac; \
curl -Lo gitleaks.tar.gz "${SOURCE}"; \
echo "${CHECKSUM}  gitleaks.tar.gz" | sha256sum -c - || exit 1; \
tar -xzvpf gitleaks.tar.gz; \
cp -avp gitleaks /usr/local/bin/gitleaks; \
rm -rf *; \
gitleaks version || exit 1; \
apk del --no-cache --no-network \
    tar; \
rm -f install_gitleaks_alpine.sh

