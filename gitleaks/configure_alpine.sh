set -ex; \
apk add --no-cache tzdata; \
cd /usr/src/app; \
rm -rf \
    /var/cache/apk/* \
    /tmp/* \
    ./*; \
adduser -S -u 1000 -G root user; \
chmod -R 755 /usr/src/app; \
chown -R user:root /usr/src/app

