FROM ghcr.io/mfem/containers/cuda:latest

ARG num_jobs
ARG cuda_arch_sm
ARG hypre_version

USER root

WORKDIR /opt/archives

RUN git clone -b v2.4.0 --single-branch --depth=1 https://github.com/NVIDIA/AMGX.git && \
    cd AMGX && \
    git submodule update --init --recursive
COPY --chown=euler:euler amgx_disable_examples.patch /opt/archives/AMGX/amgx_disable_examples.patch
RUN cd AMGX && git apply amgx_disable_examples.patch && \
    mkdir build && cd build && \
    cmake .. \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DBUILD_SHARED_LIBS=ON \
    -DCUDA_ARCH=${cuda_arch_sm} \
    -DCMAKE_BUILD_TYPE=Release && \
    make -j ${num_jobs} && make install

USER euler
WORKDIR /home/euler

ENV PATH=$PATH:/usr/local/cuda/bin

COPY --chown=euler:euler user.mk mfem/config/user.mk
RUN sed -i 's/CUDA_ARCH_SM_PLACEHOLDER/sm_${cuda_arch_sm}/' mfem/config/user.mk
RUN cd mfem && make config && make -j ${num_jobs} && cd examples && make ex1 && make ex1p