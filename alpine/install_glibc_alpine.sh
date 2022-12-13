set -ex; \
ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download"; \
ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-${GLIBC_VERSION}.apk"; \
ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-${GLIBC_VERSION}.apk"; \
ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-${GLIBC_VERSION}.apk"; \
apk add --no-cache --virtual=.build-dependencies \
    wget \
    ca-certificates; \
echo \
    "-----BEGIN PUBLIC KEY-----\
    MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApZ2u1KJKUu/fW4A25y9m\
    y70AGEa/J3Wi5ibNVGNn1gT1r0VfgeWd0pUybS4UmcHdiNzxJPgoWQhV2SSW1JYu\
    tOqKZF5QSN6X937PTUpNBjUvLtTQ1ve1fp39uf/lEXPpFpOPL88LKnDBgbh7wkCp\
    m2KzLVGChf83MS0ShL6G9EQIAUxLm99VpgRjwqTQ/KfzGtpke1wqws4au0Ab4qPY\
    KXvMLSPLUp7cfulWvhmZSegr5AdhNw5KNizPqCJT8ZrGvgHypXyiFvvAH5YRtSsc\
    Zvo9GI2e2MaZyo9/lvb+LbLEJZKEQckqRj4P26gmASrZEPStwc+yqy1ShHLA0j6m\
    1QIDAQAB\
    -----END PUBLIC KEY-----" | sed 's/   */\n/g' > "/etc/apk/keys/sgerrand.rsa.pub"; \
wget \
    "${ALPINE_GLIBC_BASE_URL}/${GLIBC_VERSION}/${ALPINE_GLIBC_BASE_PACKAGE_FILENAME}" \
    "${ALPINE_GLIBC_BASE_URL}/${GLIBC_VERSION}/${ALPINE_GLIBC_BIN_PACKAGE_FILENAME}" \
    "${ALPINE_GLIBC_BASE_URL}/${GLIBC_VERSION}/${ALPINE_GLIBC_I18N_PACKAGE_FILENAME}"; \
case $(echo "${GLIBC_VERSION}" | awk -F[\.] '{print $1"."$2}' | awk -F[\-] '{print $1}') in \
  '2.34') \
    sha256_glibc_base="3ef4a8d71777b3ccdd540e18862d688e32aa1c7bc5a1c0170271a43d0e736486"; \
    sha256_glibc_bin="cc631135f481644ce74b28f6e37ceea848de06389d669182a012a9ca1ac5a95a"; \
    sha256_glibc_i18n="265e3cd7e958be00e3aa16b7713e958d7eaa43290d0aab89ae6fc80267e18dd4"; \
    ;; \
  '2.35') \
    sha256_glibc_base="02fe2d91f53eab93c64d74485b80db575cfb4de40bc0d12bf55839fbe16cb041"; \
    sha256_glibc_bin="720b870b51f64324e318370eda080b5ee99332c36b80be975968136e06c1af93"; \
    sha256_glibc_i18n="171062071e7db01e4daefc2acdb798da5ed410df1078226d755c08c46c124063"; \
    ;; \
esac; \
echo "${sha256_glibc_base}  ${ALPINE_GLIBC_BASE_PACKAGE_FILENAME}" | sha256sum -c - || exit 1; \
echo "${sha256_glibc_bin}  ${ALPINE_GLIBC_BIN_PACKAGE_FILENAME}" | sha256sum -c - || exit 1; \
echo "${sha256_glibc_i18n}  ${ALPINE_GLIBC_I18N_PACKAGE_FILENAME}" | sha256sum -c - || exit 1; \
apk add --no-cache --force-overwrite \
    "${ALPINE_GLIBC_BASE_PACKAGE_FILENAME}" \
    "${ALPINE_GLIBC_BIN_PACKAGE_FILENAME}" \
    "${ALPINE_GLIBC_I18N_PACKAGE_FILENAME}"; \
apk fix --force-overwrite alpine-baselayout-data; \
rm -f "/etc/apk/keys/sgerrand.rsa.pub"; \
(/usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "${LANG}" || true); \
echo "export LANG=${LANG}" > /etc/profile.d/locale.sh; \
apk del glibc-i18n; \
rm -f "/root/.wget-hsts"; \
apk del .build-dependencies; \
rm -f \
    "${ALPINE_GLIBC_BASE_PACKAGE_FILENAME}" \
    "${ALPINE_GLIBC_BIN_PACKAGE_FILENAME}" \
    "${ALPINE_GLIBC_I18N_PACKAGE_FILENAME}"; \
rm -f install_glibc_alpine.sh

