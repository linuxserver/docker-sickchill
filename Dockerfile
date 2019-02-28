FROM lsiobase/alpine.python:3.9

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SICKCHILL_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="homerr"

# set python to use utf-8 rather than ascii
ENV PYTHONIOENCODING="UTF-8"

RUN \
 echo "**** upgrade packages ****" && \
 apk add --no-cache --upgrade && \
echo "**** fetch sickchill ****" && \
 mkdir -p\
	/app/sickchill && \
 if [ -z ${SICKCHILL_RELEASE}+x} ]; then \
 SICKCHILL_RELEASE=$(curl -sX GET "https://api.github.com/repos/sickchill/sickchill/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
 /tmp/sickchill.tar.gz -L \
	"https://github.com/sickchill/sickchill/archive/${SICKCHILL_RELEASE}.tar.gz" && \
 tar xf \
 /tmp/sickchill.tar.gz -C \
	/app/sickchill/ --strip-components=1

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8081
VOLUME /config /downloads /tv
