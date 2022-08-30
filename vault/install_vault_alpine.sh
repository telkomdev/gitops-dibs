set -ex; \
addgroup vault; \
adduser -S -G vault vault; \
apk add --no-cache \
    ca-certificates \
    gnupg \
    openssl \
    libcap \
    su-exec \
    dumb-init \
    tzdata; \
apkArch="$(apk --print-arch)"; \
case "${apkArch}" in 
  x86_64) \
    ARCH='amd64'; \
    ;; \
  *) \
    echo >&2 "error: unsupported architecture: ${apkArch}"; \
    exit 1; \
    ;; \
esac; \
VAULT_GPGKEY=C874011F0AB405110D02105534365D9472D7468F; \
found=''; \
for server in \
  hkps://keys.openpgp.org \
  hkps://keyserver.ubuntu.com \
  hkps://pgp.mit.edu; \
do \
  echo "Fetching GPG key ${VAULT_GPGKEY} from $server"; \
  gpg --batch --keyserver "$server" --recv-keys "${VAULT_GPGKEY}"; \
  found=yes; \
  break; \
done; \
if test -z "${found}"; then \
  echo >&2 "error: failed to fetch GPG key ${VAULT_GPGKEY}"; \
  exit; \
fi; \
mkdir -p /tmp/build; \
cd /tmp/build; \
wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${ARCH}.zip; \
wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS; \
wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig; \
gpg --batch --verify vault_${VAULT_VERSION}_SHA256SUMS.sig vault_${VAULT_VERSION}_SHA256SUMS; \
grep vault_${VAULT_VERSION}_linux_${ARCH}.zip vault_${VAULT_VERSION}_SHA256SUMS | sha256sum -c || exit 1; \
unzip -d /tmp/build vault_${VAULT_VERSION}_linux_${ARCH}.zip; \
cp /tmp/build/vault /bin/vault; \
if [ -f /tmp/build/EULA.txt ]; then \
  mkdir -p /usr/share/doc/vault; \
  mv /tmp/build/EULA.txt /usr/share/doc/vault/EULA.txt; \
fi; \
if [ -f /tmp/build/TermsOfEvaluation.txt ]; then \
  mkdir -p /usr/share/doc/vault; \
  mv /tmp/build/TermsOfEvaluation.txt /usr/share/doc/vault/TermsOfEvaluation.txt; \
fi; \
cd /tmp; \
rm -rf /tmp/build; \
gpgconf --kill dirmngr; \
gpgconf --kill gpg-agent; \
apk del --no-cache --no-network \
    gnupg \
    openssl; \
rm -rf /root/.gnupg; \
mkdir -p /vault/logs; \
mkdir -p /vault/file; \
mkdir -p /vault/config; \
chown -R vault:vault /vault; \
vault --version || exit 1; \
rm -f install_vault_alpine.sh

