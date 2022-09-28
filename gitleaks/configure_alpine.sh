set -ex; \
apk add --no-cache tzdata; \
cd /usr/src/app; \
rm -rf \
    /var/cache/apk/* \
    /tmp/* \
    configure_alpine.sh \
    install_glibc_alpine.sh \
    install_oci_alpine.sh \
    install_wkhtmltopdf_alpine.sh

