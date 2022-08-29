set -ex; \
savedAptMark="$(apt-mark showmanual)"; \
apt-get update -y; \
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl; \
apt-get install -y --no-install-recommends \
  dirmngr \
  gnupg; \
for key in \
  6A010C5166006599AA17F08146C2130DFD2497F5; \
do \
  gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "${key}" || gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${key}"; \
done; \
curl -fsSLO --compressed "https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz"; \
curl -fsSLO --compressed "https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz.asc"; \
gpg --batch --verify yarn-v${YARN_VERSION}.tar.gz.asc yarn-v${YARN_VERSION}.tar.gz; \
mkdir -p /opt; \
tar -xzf yarn-v${YARN_VERSION}.tar.gz -C /opt/; \
ln -s /opt/yarn-v${YARN_VERSION}/bin/yarn /usr/local/bin/yarn; \
ln -s /opt/yarn-v${YARN_VERSION}/bin/yarnpkg /usr/local/bin/yarnpkg; \
rm yarn-v${YARN_VERSION}.tar.gz.asc yarn-v${YARN_VERSION}.tar.gz; \
apt-mark auto '.*' > /dev/null; \
{ [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; }; \
find /usr/local -type f -executable -exec ldd '{}' ';' | awk '/=>/ { print $(NF-1) }' | sort -u | xargs -r dpkg-query --search | cut -d: -f1 | sort -u | xargs -r apt-mark manual; \
apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
yarn --version || exit 1; \
rm -f install_yarn_debian.sh

