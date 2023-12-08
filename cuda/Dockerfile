FROM ghcr.io/mfem/containers/base:latest

ARG num_jobs
ARG cuda_arch_sm
ARG hypre_version

USER root

WORKDIR /opt/archives

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb \
    && dpkg -i cuda-keyring_1.1-1_all.deb \
    && apt-get update \
    && apt-get install -y cuda-toolkit-11-8 nvidia-container-toolkit

# hypre
RUN curl -L https://github.com/hypre-space/hypre/archive/refs/tags/v${hypre_version}.tar.gz > /opt/archives/hypre-v${hypre_version}.tar.gz
RUN tar xzf hypre-v${hypre_version}.tar.gz && cd hypre-${hypre_version}/src && \
    ./configure --prefix /usr/local --enable-shared --disable-static \
    --with-cuda --with-gpu-arch=${cuda_arch_sm} --with-cuda-home=/usr/local/cuda && \
    make -j ${num_jobs} && make install

USER euler
WORKDIR /home/euler

ENV PATH=$PATH:/usr/local/cuda/bin

RUN git clone --depth=1 https://github.com/mfem/mfem.git mfem
COPY --chown=euler:euler user.mk mfem/config/user.mk
RUN sed -i 's/CUDA_ARCH_SM_PLACEHOLDER/sm_${cuda_arch_sm}/' mfem/config/user.mk
RUN cd mfem && make config && make -j ${num_jobs} && cd examples && make ex1 && make ex1p