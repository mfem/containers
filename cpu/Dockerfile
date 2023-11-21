FROM ghcr.io/mfem/containers/base:latest

ARG num_jobs
ARG hypre_version

USER root

WORKDIR /opt/archives

# hypre
RUN curl -L https://github.com/hypre-space/hypre/archive/refs/tags/v${hypre_version}.tar.gz > /opt/archives/hypre-v${hypre_version}.tar.gz
RUN tar xzf hypre-v${hypre_version}.tar.gz && cd hypre-${hypre_version}/src && \
    ./configure --prefix /usr/local --enable-shared --disable-static && \
    make -j ${num_jobs} && make install

USER euler
WORKDIR /home/euler

# MFEM repo checkout
RUN git clone --depth=1 https://github.com/mfem/mfem.git mfem
COPY --chown=euler:euler user.mk mfem/config/user.mk
# Run config/make s.t. first use is a bit quicker
# RUN cd mfem && make config && make -j ${num_jobs} && cd examples && make ex1 && make ex1p