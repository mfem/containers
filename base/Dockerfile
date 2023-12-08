FROM ubuntu:22.04

ARG num_jobs

RUN apt-get update && apt-get install -y \
   curl git git-lfs clang clang-tools clangd cmake autoconf \
   automake gdb git libffi-dev zlib1g-dev python3-pip \
   libssl-dev xz-utils pkgconf gfortran openmpi-bin libopenmpi-dev \
   wget libarchive-tools htop libmetis-dev libparmetis-dev libopenblas-dev

RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100 && \
   update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100

ENV OMPI_CC=clang
ENV OMPI_CXX=clang++
ENV LD_LIBRARY_PATH=/usr/local/lib

RUN useradd --create-home --shell /bin/bash euler

USER euler
WORKDIR /home/euler