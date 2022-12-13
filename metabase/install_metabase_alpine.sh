set -ex; \
apk add --no-cache \
    fontconfig \
    libretls \
    musl-locales \
    musl-locales-lang \
    ttf-dejavu \
    tzdata \
    zlib; \
rm -rf /var/cache/apk/*; \
ARCH="$(apk --print-arch)"; \
case "${ARCH}" in \
  amd64|x86_64) \
    ESUM='96d26887d042f3c5630cca208b6cd365679a59bf9efb601b28363e827439796c'; \
    BINARY_URL='https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.17%2B8/OpenJDK11U-jre_x64_alpine-linux_hotspot_11.0.17_8.tar.gz'; \
    ;; \
  *) \
    echo "Unsupported arch: ${ARCH}"; \
    exit 1; \
    ;; \
esac; \
wget -O /tmp/openjdk.tar.gz "${BINARY_URL}"; \
echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
mkdir -p "$JAVA_HOME"; \
tar --extract --file /tmp/openjdk.tar.gz --directory "${JAVA_HOME}" --strip-components 1 --no-same-owner; \
rm /tmp/openjdk.tar.gz; \
echo Verifying install ...; \
fileEncoding="$(echo 'System.out.println(System.getProperty("file.encoding"))' | jshell -s -)"; \
[ "$fileEncoding" = 'UTF-8' ]; \
rm -rf ~/.java; \
echo java --version; \
java --version || exit 1; \
apk add -U bash ttf-dejavu fontconfig curl java-cacerts; \
apk upgrade; \
rm -rf /var/cache/apk/*; \
mkdir -p /app/certs; \
curl https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -o /app/certs/rds-combined-ca-bundle.pem; \
/opt/java/openjdk/bin/keytool -noprompt -import -trustcacerts -alias aws-rds -file /app/certs/rds-combined-ca-bundle.pem -keystore /etc/ssl/certs/java/cacerts -keypass changeit -storepass changeit; \
curl https://cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem -o /app/certs/DigiCertGlobalRootG2.crt.pem; \
/opt/java/openjdk/bin/keytool -noprompt -import -trustcacerts -alias azure-cert -file /app/certs/DigiCertGlobalRootG2.crt.pem -keystore /etc/ssl/certs/java/cacerts -keypass changeit -storepass changeit; \
mkdir -p "${METABASE_HOME}/data/plugins"; \
chmod a+rwx "${METABASE_HOME}/data/plugins"; \
METABASE_URL="https://downloads.metabase.com/v${METABASE_VERSION}/metabase.jar"; \
case $(echo ${GOLANG_VERSION} | awk -F[\.] '{print $1"."$2}') in \
  '0.45') \
    sha256='98e470861e60056190d27fb619a6e39d37f341e235d5acbc045a882da0a71603'; \
    ;; \
esac; \
wget -qo "${METABASE_HOME}/metabase.jar" "${METABASE_URL}"; \
echo "${sha256} ${METABASE_HOME}/metabase.jar" | sha256sum -c -; \
rm -f install_metabase_alpine.sh

