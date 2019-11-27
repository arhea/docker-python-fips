FROM ubuntu:16.04 AS openssl

ENV PATH /usr/local/bin:$PATH
ENV LANG C.UTF-8

ARG OPENSSL_FIPS_VERSION=2.0.16
ARG OPENSSL_VERSION=1.0.2t
ARG PYTHON_VERSION=3.8.0

RUN mkdir -p /usr/local/src/ \
  && apt-get update -y \
  && apt-get -y install \
    curl \
    make \
    cmake \
    bzip2 \
    g++ \
    build-essential \
    libc6 \
    tcl-dev \
    tk-dev \
    libbz2-dev \
    zlib1g-dev \
    libffi-dev \
    libcups2-dev \
    libkrb5-dev \
    libyaml-dev \
    libqt4-dev \
    libsqlite3-dev \
    libffi-dev \
    libxml2-dev \
    libxslt-dev

WORKDIR /usr/local/src/

## download source
RUN set -ex \
    && curl -O https://www.openssl.org/source/openssl-fips-${OPENSSL_FIPS_VERSION}.tar.gz \
    && curl -O https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
    && curl -O https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-${PYTHON_VERSION}.tar.xz

# compile fips module
RUN set -ex \
    && tar -xvf openssl-fips-${OPENSSL_FIPS_VERSION}.tar.gz \
    && cd openssl-fips-${OPENSSL_FIPS_VERSION} \
    && ./config \
    && make \
    && make install \
    && cd ../ \
    && rm -f openssl-fips-${OPENSSL_FIPS_VERSION}.tar.gz \
    && rm -rf ./openssl-fips-${OPENSSL_FIPS_VERSION}

# compile openssl
RUN set -ex \
    && tar -xvf openssl-${OPENSSL_VERSION}.tar.gz \
    && cd openssl-${OPENSSL_VERSION} \
    && ./config shared fips \
    && make \
    && make install \
    && echo "/usr/local/ssl/lib" > /etc/ld.so.conf.d/openssl-${OPENSSL_VERSION}.conf \
    && ldconfig -v \
    && cd ../ \
    && rm -f openssl-${OPENSSL_VERSION}.tar.gz \
    && rm -rf ./openssl-${OPENSSL_VERSION} \
    && mkdir -p /usr/local/ssl/lib/shared \
    && cp /usr/local/ssl/lib/libcrypto.so.1.0.0 /usr/local/ssl/lib/shared/libcrypto.so.1.0.0 \
    && cp /usr/local/ssl/lib/libssl.so.1.0.0 /usr/local/ssl/lib/shared/libssl.so.1.0.0 \
    && ln -sf /usr/local/ssl/lib/shared/libcrypto.so.1.0.0 /usr/local/ssl/lib/shared/libcrypto.so \
    && ln -sf /usr/local/ssl/lib/shared/libssl.so.1.0.0 /usr/local/ssl/lib/shared/libssl.so \
    && rm -f /usr/local/ssl/lib/libcrypto.so /usr/local/ssl/lib/libssl.so \
    && ln -sf /usr/local/ssl/bin/openssl /usr/bin/openssl \
    && OPENSSL_FIPS=1 openssl version

ENV OPENSSL_FIPS=1
ENV PATH=$PATH:/usr/local/ssl/bin
ENV LDFLAGS="-L/usr/local/ssl/lib/ -L//usr/local/ssl/lib64/"
ENV LD_LIBRARY_PATH="/usr/local/ssl/lib/:/usr/local/ssl/lib64/"
ENV CPPFLAGS="-I/usr/local/ssl/include -I/usr/local/ssl/include/openssl"
ENV CFLAGS="-I/usr/local/ssl/include"

# compile python
RUN set -ex \
    && tar -xvf Python-${PYTHON_VERSION}.tar.xz \
    && cd Python-${PYTHON_VERSION} \
    && ./configure --enable-optimizations --enable-shared --without-ensurepip \
    && make \
    && make install \
    && ldconfig \
    && cd ../ \
    && python3 --version \
    && ln -sf /usr/local/bin/idle3 /usr/local/bin/idle \
	  && ln -sf /usr/local/bin/pydoc3 /usr/local/bin/pydoc \
	  && ln -sf /usr/local/bin/python3 /usr/local/bin/python \
	  && ln -sf /usr/local/bin/python3-config /usr/local/bin/python-config \
    && rm -f Python-${PYTHON_VERSION}.tar.xz \
    && rm -rf Python-${PYTHON_VERSION}

RUN set -ex \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3 get-pip.py \
    && pip install cryptography --no-binary cryptography

# run a final test
RUN openssl version && python3 --version

ENTRYPOINT [ "/usr/local/bin/python3" ]

CMD ["-c", "import ssl; print(ssl.OPENSSL_VERSION)"]
