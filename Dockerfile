# https://github.com/jandelgado/docker-crosscompile-example
# use docker and qemu to cross compile for the raspberry pi
#
ARG BASE=debian:buster-slim

FROM alpine:3.14 AS qemu-helper

# stage just used to provide qemu-*-static binaries.
ARG QEMU_ARCHS="aarch64 arm"
ARG QEMU_VERSION="6.0.0-2"
RUN apk update && apk add curl \
 && for arch in ${QEMU_ARCHS}; do \
    curl -L https://github.com/multiarch/qemu-user-static/releases/download/v${QEMU_VERSION}/x86_64_qemu-${arch}-static.tar.gz \
        | tar zxvf - -C /usr/bin; done \
 && chmod +x /usr/bin/qemu-*
FROM $BASE
MAINTAINER "Jan Delgado <jdelgado@gmx.net>"

# needed for cross-building raspi images 
COPY --from=qemu-helper /usr/bin/qemu-aarch64-static /usr/bin/
COPY --from=qemu-helper /usr/bin/qemu-arm-static /usr/bin/

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
            build-essential git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

ARG USER=builder
RUN useradd -ms /bin/bash $USER

USER $USER 
WORKDIR /home/$USER

ENTRYPOINT ["/bin/bash"]

