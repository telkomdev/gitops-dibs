set -ex; \
apk add --no-cache \
    libstdc++ \
    libx11 \
    libxrender \
    libxext \
    libssl1.1 \
    ca-certificates \
    fontconfig \
    freetype \
    ttf-dejavu \
    ttf-droid \
    ttf-freefont \
    ttf-liberation; \
apk add --no-cache --virtual .build-deps \
    msttcorefonts-installer; \
update-ms-fonts; \
fc-cache -f; \
rm -rf /tmp/*; \
apk del .build-deps; \ 
rm -f install_wkhtmltopdf_alpine.sh

