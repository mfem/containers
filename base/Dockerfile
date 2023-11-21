FROM ubuntu:22.04

ARG num_jobs

RUN apt-get update && apt-get install -y \
   curl git git-lfs clang clang-tools clangd cmake autoconf \
   automake gdb git libffi-dev zlib1g-dev python3-pip \
   libssl-dev xz-utils pkgconf gfortran openmpi-bin libopenmpi-dev \
   wget libarchive-tools htop

RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100 && \
   update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100

ENV OMPI_CC=clang
ENV OMPI_CXX=clang++
ENV LD_LIBRARY_PATH=/usr/local/lib

WORKDIR /opt/archives

# metis
RUN curl -L https://github.com/mfem/tpls/blob/gh-pages/metis-5.1.0.tar.gz?raw=true > /opt/archives/metis-5.1.0.tgz
RUN tar xzf metis-5.1.0.tgz && cd metis-5.1.0 && \
   make config shared=1 cc=mpicc prefix=/usr/local && make -j ${num_jobs} && make install

RUN useradd --create-home --shell /bin/bash euler

USER euler
WORKDIR /home/euler