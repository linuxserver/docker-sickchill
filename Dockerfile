FROM lsiobase/alpine:3.12

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SICKCHILL_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="homerr"

# set python to use utf-8 rather than ascii
ENV PYTHONIOENCODING="UTF-8"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	libffi-dev \
	make \
	openssl-dev \
	python3-dev && \
 echo "**** install packages ****" && \
 apk add --no-cache \
	libmediainfo \
	py3-pip \
	python3 && \
 echo "**** install sickchill ****" && \
 if [ -z ${SICKCHILL_VERSION+x} ]; then \
        SICKCHILL="sickchill"; \
 else \
        SICKCHILL="sickchill==${SICKCHILL_VERSION}"; \
 fi && \
 pip3 install -U \
	pip && \
 pip install -U \
	"$SICKCHILL" && \
 ln -s /usr/bin/python3 /usr/bin/python && \
 echo "**** clean up ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8081
VOLUME /config
