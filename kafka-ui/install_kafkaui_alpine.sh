set -ex; \
apk add --no-cache \
    openjdk13-jre; \
apk add --no-cache \
    curl; \
curl -Lo kafka-ui-api.jar "https://github.com/provectus/kafka-ui/releases/download/v${KAFKA_UI_VERSION}/kafka-ui-api-v${KAFKA_UI_VERSION}.jar"; \
case $(echo ${KAFKA_UI_VERSION} | awk -F[\.] '{print $1"."$2}') in \
  '0.4') \
    sha256="cedd15fab7de6d3f4616b69b5e9f3e456a57e927bc7809e2e8f6bc500670ac68"; \
    ;; \
esac; \
echo "${sha256}  kafka-ui-api.jar" | sha256sum -c - || exit 1; \
apk del --purge \
    curl; \
rm -f install_kafkaui_alpine.sh

