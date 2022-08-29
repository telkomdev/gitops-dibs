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
sha256_glibc_base="02fe2d91f53eab93c64d74485b80db575cfb4de40bc0d12bf55839fbe16cb041"; \
sha256_glibc_bin="720b870b51f64324e318370eda080b5ee99332c36b80be975968136e06c1af93"; \
sha256_glibc_i18n="171062071e7db01e4daefc2acdb798da5ed410df1078226d755c08c46c124063"; \
echo "${sha256_glibc_base}  ${ALPINE_GLIBC_BASE_PACKAGE_FILENAME}" | sha256sum -c - || exit 1; \
echo "${sha256_glibc_bin}  ${ALPINE_GLIBC_BIN_PACKAGE_FILENAME}" | sha256sum -c - || exit 1; \
echo "${sha256_glibc_i18n}  ${ALPINE_GLIBC_I18N_PACKAGE_FILENAME}" | sha256sum -c - || exit 1; \
apk add --no-cache \
    "${ALPINE_GLIBC_BASE_PACKAGE_FILENAME}" \
    "${ALPINE_GLIBC_BIN_PACKAGE_FILENAME}" \
    "${ALPINE_GLIBC_I18N_PACKAGE_FILENAME}"; \
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
rm -f install_glibc.sh

