set -ex; \
apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    tzdata; \
apt-get autoclean -y; \
apt-get clean -y; \
cd /usr/src/app; \
rm -rf /var/cache/apt/* \
    /var/lib/apt/lists/* \
    /tmp/* \
    ./*; \
useradd -r -s /usr/sbin/nologin -u 1000 -g root user; \
chmod -R 755 /usr/src/app; \
chown -R user:root /usr/src/app

