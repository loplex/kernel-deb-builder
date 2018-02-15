FROM lopin/kernel-deb-builder

RUN mkdir -p /build/linux /build/patches && cd /build/linux && \
	apt-get update && apt-get --download-only source linux && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

ARG DEBEMAIL='Anonymous Anonymous <anonymous@domain.org>'
#ARG DEBCHANGE_OPTIONS="--nmu"
ARG DEBCHANGE_OPTIONS="-l +custom"
ARG ARCH=amd64
ARG FEATURESET=none
ARG FLAVOUR=amd64
ARG MAKEFLAGS
ARG DEBIAN_KERNEL_DISABLE_DEBUG=yes

VOLUME /build

COPY patches /build/patches
COPY scripts /build

RUN chmod +x /build/build.sh && sleep 1 && \
	env DEBEMAIL="$DEBEMAIL" DEBCHANGE_OPTIONS="$DEBCHANGE_OPTIONS" \
	ARCH="$ARCH" FEATURESET="$FEATURESET" FLAVOUR="$FLAVOUR" \
	MAKEFLAGS="$MAKEFLAGS" \
	/build/build.sh

