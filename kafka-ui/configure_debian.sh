set -ex; \
apt-get install -y --no-install-recommends \
        tzdata; \
apt-get autoremove -y --purge; \
apt-get autoclean -y; \
apt-get clean -y; \
cd /usr/src/app; \
rm -rf /var/cache/apt/* \
    /var/lib/apt/lists/* \
    /tmp/* \
    ./*

