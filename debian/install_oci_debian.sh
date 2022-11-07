set -ex; \
apt-get update -y; \
apt-get install -y --no-install-recommends \
    libaio1; \
apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    unzip; \
curl -Lo instantclient.zip "https://download.oracle.com/otn_software/linux/instantclient/217000/instantclient-basiclite-linux.x64-${INSTANT_CLIENT_VERSION}.0.0dbru.zip"; \
sha256_oci="8a745ad7f4290ff8f7bd1d9436f6afdf07644e390b5d6acc3dc50978687795cb"; \
echo "${sha256_oci}  instantclient.zip" | sha256sum -c - || exit 1; \
unzip instantclient.zip; \
rm -f instantclient.zip; \
mkdir -p ${ORACLE_BASE}; \
mv instantclient_*/* ${ORACLE_BASE}/; \
rm -rf instantclient_*; \
echo "${ORACLE_BASE}" > /etc/ld.so.conf.d/oracle-instantclient.conf; \
ldconfig; \
ldd ${ORACLE_BASE}/libclntsh.so || exit 1; \
ldd ${ORACLE_BASE}/libocci.so || exit 1; \
ldd ${ORACLE_BASE}/libociicus.so || exit 1; \
ldd ${ORACLE_BASE}/libnnz21.so || exit 1; \
apt-get remove -y --purge \
    ca-certificates \
    curl \
    unzip; \
rm -f install_oci_debian.sh

