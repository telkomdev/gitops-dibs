set -ex; \
apt-get install -y --no-install-recommends \
        tzdata; \
apt-get autoremove -y --purge; \
apt-get autoclean -y; \
apt-get clean -y; \
rm -rf rm -rf /var/lib/apt/lists/*; \
rm -f configure_debian.sh

