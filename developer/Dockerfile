ARG base_image

FROM ghcr.io/mfem/containers/${base_image}:latest

ARG cuda_arch_sm
ARG mfem_use_cuda=NO
ARG mfem_use_petsc=NO
ARG mfem_use_superlu=NO

USER root

WORKDIR /opt/archives

RUN apt-get update && apt-get install -y supervisor python3-websockets nginx

# OpenVSCode server
RUN curl -L https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v1.69.1/openvscode-server-v1.69.1-linux-x64.tar.gz > \
    /opt/archives/openvscode-server-v1.69.1-linux-x64.tar.gz
RUN tar xzf openvscode-server-v1.69.1-linux-x64.tar.gz && chown -R euler:euler openvscode-server-v1.69.1-linux-x64

USER euler
WORKDIR /home/euler

# Create compile_commands for clangd plugin. Options must match the features
# the base image's MFEM was built with, or clangd greys out enabled code.
# CUDA is compiled with clang since clangd cannot parse nvcc command lines.
# PETSc is a prefix install, so PETSC_ARCH must be empty.
RUN cmake -S mfem -B mfem/build \
        -DMFEM_USE_MPI=YES \
        -DMFEM_USE_ENZYME=YES \
        -DENZYME_DIR=/usr/local \
        -DMFEM_USE_PETSC=${mfem_use_petsc} \
        -DPETSC_DIR=/usr/local \
        -DPETSC_ARCH= \
        -DMFEM_USE_SUPERLU=${mfem_use_superlu} \
        -DSuperLUDist_DIR=/usr/local \
        -DMFEM_USE_CUDA=${mfem_use_cuda} \
        -DCMAKE_CUDA_COMPILER=clang++ \
        -DCMAKE_CUDA_ARCHITECTURES=${cuda_arch_sm} \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

# Install OpenVSCode as user
RUN mkdir -p ${HOME}/.openvscode-server/extensions
RUN cd  ${HOME}/.openvscode-server/extensions && \
    curl -L https://openvsxorg.blob.core.windows.net/resources/llvm-vs-code-extensions/vscode-clangd/0.1.21/llvm-vs-code-extensions.vscode-clangd-0.1.21.vsix > clangd.vsix && \
    bsdtar -xvf clangd.vsix extension && \
    mv extension llvm-vs-code-extensions.vscode-clangd-0.1.21

# GLVis JS
RUN git lfs install && git clone --depth=1 https://github.com/GLVis/glvis-js.git

USER root
ADD supervisord.conf /etc/supervisord.conf

# Reverse proxy: expose VSCode, the GLVis viewer, and the GLVis websocket on
# the single tutorial port (3000), routed by path.
ADD nginx.conf /etc/nginx/nginx.conf

RUN touch /var/log/glvis-js-webserver.log /var/log/glvis-browser-server.log /var/log/openvscode-server.log /var/log/nginx.log && \
    chown -R euler:euler /var/log/glvis-js-webserver.log /var/log/glvis-browser-server.log /var/log/openvscode-server.log /var/log/nginx.log

CMD ["/usr/bin/supervisord"]
