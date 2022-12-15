set -ex; \
apk add --no-cache \
    curl \
    ca-certificates \
    tar; \
alpineArch="$(apk --print-arch)"; \
case "${alpineArch##*-}" in \
  x86_64) \
    SOURCE="https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz"; \
    case $(echo "${TRIVY_VERSION}" | awk -F[\.] '{print $1"."$2}') in \
      '0.31') \
        CHECKSUM="aef718fd3e6e0714308f35ae567d6442f4ddd351e900d083d4e6e97a7368df73"; \
        ;; \
      '0.34') \
        CHECKSUM="53f176ca461412563cec7199798ad9acf8bbb38527c0d9a38f745442f022f111"; \
        ;; \
      '0.35') \
        CHECKSUM="ebc1dd4d4c0594028d6a501dfc1a73d56add20b29d3dee5ab6e64aac94b1d526"; \
        ;; \
      esac; \
    ;; \
  *) \
    ;; \
esac; \
curl -Lo trivy.tar.gz "${SOURCE}"; \
echo "${CHECKSUM}  trivy.tar.gz" | sha256sum -c - || exit 1; \
tar -xzvpf trivy.tar.gz; \
cp -avp trivy /usr/local/bin/trivy; \
mkdir -p /contrib; \
cp -avp contrib/*.tpl /contrib; \
rm -rf *; \
trivy version || exit 1; \
apk del --no-cache --no-network \
    tar; \
rm -f install_trivy_alpine.sh

