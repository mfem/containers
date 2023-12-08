ARG base_image
FROM ghcr.io/mfem/containers/${base_image}:latest

USER root

WORKDIR /opt/archives

RUN apt-get update && apt-get install -y supervisor

# OpenVSCode server
RUN curl -L https://github.com/gitpod-io/openvscode-server/releases/download/openvscode-server-v1.69.1/openvscode-server-v1.69.1-linux-x64.tar.gz > \
    /opt/archives/openvscode-server-v1.69.1-linux-x64.tar.gz
RUN tar xzf openvscode-server-v1.69.1-linux-x64.tar.gz && chown -R euler:euler openvscode-server-v1.69.1-linux-x64

USER euler
WORKDIR /home/euler

ADD --chown=euler:euler clangd_compile_flags.txt ./mfem/compile_flags.txt

# Install OpenVSCode as user
RUN mkdir -p ${HOME}/.openvscode-server/extensions
RUN cd  ${HOME}/.openvscode-server/extensions && \
    curl -L https://openvsxorg.blob.core.windows.net/resources/llvm-vs-code-extensions/vscode-clangd/0.1.21/llvm-vs-code-extensions.vscode-clangd-0.1.21.vsix > clangd.vsix && \
    bsdtar -xvf clangd.vsix extension && \
    mv extension llvm-vs-code-extensions.vscode-clangd-0.1.21

RUN curl -L https://github.com/aaugustin/websockets/archive/refs/tags/10.3.tar.gz > ./websockets-10.3.tar.gz && \
    tar xzf websockets-10.3.tar.gz && \
    cd websockets-10.3 && \
    pip install --user .

# GLVis JS
RUN git lfs install && git clone --depth=1 https://github.com/GLVis/glvis-js.git

USER root
ADD supervisord.conf /etc/supervisord.conf
RUN touch /var/log/glvis-js-webserver.log /var/log/glvis-browser-server.log /var/log/openvscode-server.log && \
    chown -R euler:euler /var/log/glvis-js-webserver.log /var/log/glvis-browser-server.log /var/log/openvscode-server.log

CMD ["/usr/bin/supervisord"]