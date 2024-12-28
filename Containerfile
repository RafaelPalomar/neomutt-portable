FROM debian:stable-slim

LABEL com.github.containers.toolbox="true" \
    usage="This image is meant to be used with the toolbox or distrobox command" \
    summary="A Debian-based distrobox container with NeoMutt and OAuth2 support for Outlook 365" \
    maintainer="rafael.palomar@ous-research.no"

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    abook \
    build-essential \
    ca-certificates \
    curl \
    gcc \
    gettext \
    git \
    gnupg2 \
    isync \
    isync \
    libcurl4-openssl-dev \
    libgpgme-dev \
    libidn2-0-dev \
    liblua5.3-dev \
    libncursesw5-dev \
    libnotmuch-dev \
    libsqlite3-dev \
    libssl-dev \
    libtokyocabinet-dev \
    libxml2-dev \
    libxml2-utils \
    libxslt1-dev \
    locales \
    make \
    msmtp \
    mutt-wizard \
    neomutt \
    notmuch \
    pass \
    libsasl2-dev \
    sasl2-bin \
    libscitokens-dev \
    pkg-config \
    python3 \
    python3-pip \
    tsocks \
    wget \
    xsltproc \
    autoconf \
    automake \
    libtool \
    libsasl2-dev \
    libcurl4-openssl-dev \
    make \
    gcc \
    git \
    vim \
    zlib1g-dev

# Set locale to avoid any locale-related issues
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# # Install Python OAuth2 client library
# RUN pip3 install --no-cache-dir --break-system-packages requests requests-oauthlib

RUN cd /tmp && \
    git clone https://github.com/moriyoshi/cyrus-sasl-xoauth2 && \
    cd  cyrus-sasl-xoauth2 && \
    ./autogen.sh && \
    ./configure --libdir=$(pkg-config --variable=libdir libsasl2) --prefix=/usr && \
    sed -i 's%pkglibdir = ${CYRUS_SASL_PREFIX}/lib/sasl2%pkglibdir = ${CYRUS_SASL_PREFIX}/lib/x86_64-linux-gnu/sasl2%' Makefile && \
    make && \
    make install

# Clone and build NeoMutt with OAuth2 support
RUN cd /tmp && \
    git clone https://github.com/neomutt/neomutt.git && \
    cd neomutt && \
    ./configure \
    --disable-doc \
    --enable-gpgme \
    --enable-notmuch \
    --enable-lua \
    --enable-idn2 \
    --with-idn2=/usr/lib/x86_64-linux-gnu/libidn2.so.0 \
    --with-tokyocabinet=yes \
    --with-sasl=libsasl2 \
    --with-ssl=openssl \
    --prefix=/usr/local && \
    make && \
    make install

RUN install /usr/local/share/neomutt/oauth2/mutt_oauth2.py /usr/bin

# Clean up to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

RUN cp  /usr/share/applications/neomutt.desktop \
        /usr/share/applications/neomutt-portable.desktop

# Verify NeoMutt installation and features
RUN neomutt -v

# Set working directory
WORKDIR /root

# Entry point for the container
CMD ["bash"]
