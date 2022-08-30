set -ex; \
apk add --no-cache tzdata; \
rm -rf /var/cache/apk/*; \
rm -rf /tmp/*; \
rm -f configure_alpine.sh

