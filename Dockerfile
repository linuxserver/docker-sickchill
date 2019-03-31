FROM lsiobase/python:3.9

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SICKCHILL_COMMIT
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="homerr"

# set python to use utf-8 rather than ascii
ENV PYTHONIOENCODING="UTF-8"

RUN \
echo "**** upgrade packages ****" && \
apk add --no-cache --upgrade && \
echo "**** fetch sickchill ****" && \
mkdir -p \
	/app/sickchill && \
if [ -z ${SICKCHILL_COMMIT+x} ]; then \
	SICKCHILL_COMMIT=$(curl -sX GET https://api.github.com/repos/sickchill/sickchill/commits/master \
	| awk '/sha/{print $4;exit}' FS='[""]'); \
fi && \
echo "found ${SICKCHILL_COMMIT}" && \
curl -o \
/tmp/sickchill.tar.gz -L \
	"https://github.com/sickchill/sickchill/archive/${SICKCHILL_COMMIT}.tar.gz" && \
tar xf \
	/tmp/sickchill.tar.gz -C \
	/app/sickchill/ --strip-components=1

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8081
VOLUME /config /downloads /tv
