# makefile for simple cross compilation using docker
# (c) copyright by Jan Delgado
# 
# Actual project is stored in ./workdir
#
# Example usage:
#	make shell-arm64v8 - start interactive bash in docker container
#	make make-arm64v7  - run "make" in workdir in docker container
#	make make-arm64v7 OPTS=clean - run "make clean" in workdir in docker container
#
.PHONY=image.arm32v7 image.arm64v8 image.amd64 image run

#HOST:=$(shell ip addr show docker0 | grep -Po 'inet \K[\d.]+')

BASE_TAG=jandelgado/raspi-docker-crosscompile

#all: image.amd64 image.arm32v7 image.arm64v8
all: image.arm64v8

image.arm64v8: BASE = arm64v8/debian:buster-slim
image.arm64v8: TAG = arm64v8
image.arm64v8: image

# image.arm32v7: BASE = arm32v7/debian:jessie-slim
# image.arm32v7: TAG= arm32v7
# image.arm32v7: image

# image.amd64: BASE = debian:jessie-slim
# image.amd64: TAG = amd64
# image.amd64: image

image:
	docker build \
			 --build-arg BASE="$(BASE)" \
	         -t "$(BASE_TAG)-linux-$(TAG)"  .

shell-arm64v8: CMD=/bin/bash
shell-arm64v8: run-arm64v8

make-arm64v8: CMD=/usr/bin/make
make-arm64v8: run-arm64v8

run-arm64v8:
	docker run --rm -ti \
		       --user $(shell id -u):$(shell id -g) \
			   -w /workdir \
			   -v $(PWD)/workdir:/workdir:z \
			   --entrypoint "$(CMD)"\
			   $(BASE_TAG)-linux-arm64v8 \
			   $(OPTS)

