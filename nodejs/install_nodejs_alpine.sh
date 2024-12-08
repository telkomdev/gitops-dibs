set -ex; \
apk add --no-cache libstdc++; \
apk add --no-cache --virtual .build-deps curl; \
ARCH=; \
alpineArch="$(apk --print-arch)"; \
case "${alpineArch##*-}" in \
  x86_64) \
    ARCH='x64'; \
    case $(echo ${NODE_VERSION} | awk -F[\.] '{print $1}') in \
      '10') \
        CHECKSUM="138eed35daca02bbc01cae161e13604b1b71139e9552d4cb9fe3aad742ce94ec"; \
        ;; \
      '12') \
        CHECKSUM="e5eb941bd3d5b7ab197e27c353049e6e8fd03d39c4949ea393f5af4ba8ef020a"; \
        ;; \
      '14') \
        CHECKSUM="b7d90dae42a75531ff4b29f3c843927c63677f7dbd30dda299ac3d3da65f828b"; \
        ;; \
      '16') \
        CHECKSUM="e6b9c39f85eed0f625b570bbb3019db8761ab78a935eb44f20865ab35c4eec6c"; \
        ;; \
      '18') \
        CHECKSUM="1ed310f338017dbe53300342457c3e7c3701e9efa7697f51b90be785476853d7"; \
        ;; \
    esac; \
    ;; \
  *) \
    ;; \
esac; \
if [ -n "${CHECKSUM}" ]; then \
  set -eu; \
  curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${ARCH}-musl.tar.xz"; \
  echo "${CHECKSUM}  node-v${NODE_VERSION}-linux-${ARCH}-musl.tar.xz" | sha256sum -c - || exit 1; \
  tar -xJf "node-v${NODE_VERSION}-linux-${ARCH}-musl.tar.xz" -C /usr/local --strip-components=1 --no-same-owner; \
  ln -s /usr/local/bin/node /usr/local/bin/nodejs; \
else \
  echo "Building from source"; \
  python_version="2"; \
  [ $(echo ${NODE_VERSION} | awk -F[\.] '{print $1}') -gt 10 ] && python_version="3"; \
  apk add --no-cache --virtual .build-deps-full binutils-gold g++ gcc gnupg libgcc linux-headers make python${python_version}; \
  for key in \
    4ED778F539E3634C779C87C6D7062848A1AB005C \
    141F07595B7B3FFE74309A937405533BE57C7D57 \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    74F12602B6F1C4E913FAA37AD3A89613643B6201 \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    61FC681DFB92A079F1685E77973F295594EC4689 \
    8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    890C08DB8579162FEE0DF9DB8BEAB4DFCF555EF4 \
    C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
    108F52B48DB57BB0CC439B2997B01419BD92F80A \
    B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    CC68F5A3106FF448322E48ED27F5E38D5B0A215F; \
  do \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "${key}" || gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${key}"; \
  done; \
  curl -fsSLO --compressed "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.tar.xz"; \
  curl -fsSLO --compressed "https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt.asc"; \
  gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc; \
  grep " node-v${NODE_VERSION}.tar.xz\$" SHASUMS256.txt | sha256sum -c -; \
  tar -xf "node-v${NODE_VERSION}.tar.xz"; \
  cd "node-v${NODE_VERSION}"; \
  ./configure; \
  make -j$(getconf _NPROCESSORS_ONLN) V=; \
  make install; \
  apk del .build-deps-full; \
  cd ..; \
  rm -Rf "node-v${NODE_VERSION}"; \
  rm "node-v${NODE_VERSION}.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt; \
fi; \
rm -f "node-v${NODE_VERSION}-linux-${ARCH}-musl.tar.xz"; \
apk del .build-deps; \
node --version || exit 1; \
npm --version || exit 1; \
rm -f install_nodejs_alpine.sh

