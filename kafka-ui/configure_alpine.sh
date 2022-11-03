set -ex; \
apk add --no-cache tzdata; \
cd /usr/src/app; \
rm -rf \
    /var/cache/apk/* \
    /tmp/* \
    ./*

