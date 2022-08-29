set -ex; \
apk add --no-cache tzdata; \
rm -rf /var/cache/apk/*; \
rm -f configure_alpine.sh

