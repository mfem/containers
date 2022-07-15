FROM ubuntu:22.04

# docker build -t mfem-developer .

RUN apt-get update && apt-get install -y \
    supervisor curl git git-lfs clang clang-tools cmake autoconf \
    automake gdb git libffi-dev zlib1g-dev python3-pip \
    libssl-dev xz-utils pkgconf gfortran openmpi-bin libopenmpi-dev

RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100 && \
    update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100

ENV OMPI_CC=clang
ENV OMPI_CXX=clang++
ENV LD_LIBRARY_PATH=/usr/local/lib

WORKDIR /opt/archives

RUN useradd --create-home --shell /bin/bash euler

# hypre
RUN curl -L https://github.com/hypre-space/hypre/archive/refs/tags/v2.19.0.tar.gz > /opt/archives/hypre-v2.19.0.tar.gz
RUN tar xzf hypre-v2.19.0.tar.gz && cd hypre-2.19.0/src && \
    ./configure --prefix /usr/local --enable-shared --disable-static && \
    make -j && make install

# metis
RUN curl -L https://github.com/mfem/tpls/blob/gh-pages/metis-5.1.0.tar.gz?raw=true > /opt/archives/metis-5.1.0.tgz
RUN tar xzf metis-5.1.0.tgz && cd metis-5.1.0 && \
    make config shared=1 cc=mpicc prefix=/usr/local && make -j && make install

# OpenVSCode server
RUN curl -L https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v1.69.1/openvscode-server-v1.69.1-linux-x64.tar.gz > \
    /opt/archives/openvscode-server-v1.69.1-linux-x64.tar.gz
RUN tar xzf openvscode-server-v1.69.1-linux-x64.tar.gz && chown -R euler:euler openvscode-server-v1.69.1-linux-x64

USER euler
WORKDIR /home/euler

# MFEM repo checkout
RUN git clone --depth=1 https://github.com/mfem/mfem.git mfem
ADD --chown=euler:euler developer/user.mk mfem/config/user.mk
# Run config/make s.t. first use is a bit quicker
RUN cd mfem && make config && make -j && cd examples && make ex1 && make ex1p

RUN curl -L https://github.com/aaugustin/websockets/archive/refs/tags/10.3.tar.gz > ./websockets-10.3.tar.gz && \
    tar xzf websockets-10.3.tar.gz && \
    cd websockets-10.3 && \
    pip install --user .

# GLVis JS
RUN git lfs install && git clone --depth=1 https://github.com/GLVis/glvis-js.git

# Patching glvis-browser-server for correct host 
ADD --chown=euler:euler developer/glvis-patch-0001.patch ./glvis-js
RUN cd glvis-js && \
    patch -u -b glvis-browser-server -i glvis-patch-0001.patch

USER root
ADD developer/supervisord.conf /etc/supervisord.conf
RUN touch /var/log/glvis-js-webserver.log /var/log/glvis-browser-server.log /var/log/openvscode-server.log && \
    chown -R euler:euler /var/log/glvis-js-webserver.log /var/log/glvis-browser-server.log /var/log/openvscode-server.log

CMD ["/usr/bin/supervisord"]