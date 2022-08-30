set -ex; \
apt-get update -y; \
apt-get install -y --no-install-recommends \
    openjdk-11-jre; \
apt-get install -y --no-install-recommends \
  curl; \
curl -Lo kafka-ui-api.jar "https://github.com/provectus/kafka-ui/releases/download/v${KAFKA_UI_VERSION}/kafka-ui-api-v${KAFKA_UI_VERSION}.jar"; \
case $(echo ${KAFKA_UI_VERSION} | awk -F[\.] '{print $1"."$2}') in \
  '0.4') \
    sha256="cedd15fab7de6d3f4616b69b5e9f3e456a57e927bc7809e2e8f6bc500670ac68"; \
    ;; \
esac; \
echo "${sha256}  kafka-ui-api.jar" | sha256sum -c - || exit 1; \
apt-get remove -y --purge \
    curl; \
rm -f install_kafkaui_debian.sh

