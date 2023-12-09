#!/bin/sh
#DBUILDOPTS="--pull --no-cache --squash"
DBUILDOPTS="--pull"
NAMESPACE="thijswithaar"

docker build ${DBUILDOPTS} -f Dockerfile.debian_sid -t ${NAMESPACE}/debian:sid .
docker push ${NAMESPACE}/debian:sid

docker build ${DBUILDOPTS} -f Dockerfile.fedora_rawhide -t ${NAMESPACE}/fedora:rawhide .
docker push ${NAMESPACE}/fedora:rawhide

docker build ${DBUILDOPTS} -f Dockerfile.ubuntu -t ${NAMESPACE}/ubuntu:devel .
docker push ${NAMESPACE}/ubuntu:devel

docker build ${DBUILDOPTS} -f Dockerfile.arch -t ${NAMESPACE}/arch:latest .
docker push ${NAMESPACE}/arch:latest

docker build ${DBUILDOPTS} -f Dockerfile.suse -t ${NAMESPACE}/suse:tumbleweed .
docker push ${NAMESPACE}/suse:tumbleweed

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker build ${DBUILDOPTS} --platform linux/arm32v7 --build-arg ARCH=arm32v7 -f Dockerfile.raspbian -t ${NAMESPACE}/raspbian:sid .
docker push ${NAMESPACE}/raspbian:sid

# yes | docker volume prune; docker container prune --force
# yes | docker image prune -a --filter "until=48h"
# docker system prune -a --force
