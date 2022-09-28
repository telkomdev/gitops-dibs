set -ex; \
GPG_KEY=A035C8C19219BA821ECEA86B64E628F8D684696D; \
export GPG_KEY; \
apk add --no-cache \
    ca-certificates \
    tzdata; \
apk add --no-cache --virtual .build-deps \
    gnupg \
    tar \
    xz \
    bluez-dev \
    bzip2-dev \
    dpkg-dev \
    dpkg \
    expat-dev \
    findutils \
    gcc \
    gdbm-dev \
    libc-dev \
    libffi-dev \
    libnsl-dev \
    libtirpc-dev \
    linux-headers \
    make \
    ncurses-dev \
    openssl-dev \
    pax-utils \
    readline-dev \
    sqlite-dev \
    tcl-dev \
    tk \
    tk-dev \
    util-linux-dev \
    xz-dev \
    zlib-dev; \
wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-${PYTHON_VERSION}.tar.xz"; \
wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-${PYTHON_VERSION}.tar.xz.asc"; \
GNUPGHOME="$(mktemp -d)"; \
export GNUPGHOME; \
gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "${GPG_KEY}"; \
gpg --batch --verify python.tar.xz.asc python.tar.xz; \
command -v gpgconf > /dev/null \
  && gpgconf --kill all || :; \
rm -rf "${GNUPGHOME}" python.tar.xz.asc; \
mkdir -p /usr/src/python; \
tar --extract --directory /usr/src/python --strip-components=1 --file python.tar.xz; \
rm python.tar.xz; \
cd /usr/src/python; \
gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
./configure --build="${gnuArch}" \
    --enable-loadable-sqlite-extensions \
    --enable-optimizations \
    --enable-option-checking=fatal \
    --enable-shared \
    --with-lto \
    --with-system-expat \
    --without-ensurepip; \
nproc="$(nproc)"; \
make -j "$nproc" EXTRA_CFLAGS="-DTHREAD_STACK_SIZE=0x100000" LDFLAGS="-Wl,--strip-all"; \
make install; \
cd /; \
rm -rf /usr/src/python; \
find /usr/local -depth \( 		\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name 'libpython*.a' \) \) \) -exec rm -rf '{}' +; \
find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec scanelf --needed --nobanner --format '%n#p' '{}' ';' | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' | xargs -rt apk add --no-network --virtual .python-rundeps; \
apk del --no-network .build-deps; \
python3 --version || exit 1; \
export PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/5eaac1050023df1f5c98b173b248c260023f2278/public/get-pip.py; \
export PYTHON_GET_PIP_SHA256=5aefe6ade911d997af080b315ebcb7f882212d070465df544e1175ac2be519b4; \
wget -O get-pip.py "${PYTHON_GET_PIP_URL}"; \
echo "${PYTHON_GET_PIP_SHA256} *get-pip.py" | sha256sum -c -; \
export PYTHONDONTWRITEBYTECODE=1; \
python3 get-pip.py \
    --disable-pip-version-check \
    --no-cache-dir \
    --no-compile "pip==${PYTHON_PIP_VERSION}" "setuptools==${PYTHON_SETUPTOOLS_VERSION}"; \
rm -f get-pip.py; \
pip --version || exit 1; \
rm -f install_python_alpine.sh

