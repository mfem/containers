FROM ghcr.io/mfem/containers/cpu:latest

ARG num_jobs

USER root

WORKDIR /opt/archives

RUN curl -L https://codeload.github.com/xiaoyeli/superlu_dist/tar.gz/refs/tags/v8.2.1 > /opt/archives/superlu-v8.2.1.tar.gz
RUN tar xzf superlu-v8.2.1.tar.gz && cd superlu_dist-8.2.1 && \
    mkdir build && cd build && \
    cmake .. \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DBUILD_SHARED_LIBS=ON \
    -DTPL_BLAS_LIBRARIES="/usr/lib/x86_64-linux-gnu/libblas.so.3" \
    -DTPL_ENABLE_METISLIB=ON \
    -DTPL_METIS_INCLUDE_DIRS="/usr/include" \
    -DTPL_METIS_LIBRARIES="/usr/lib/x86_64-linux-gnu/libmetis.so" \
    -DTPL_PARMETIS_INCLUDE_DIRS="/usr/include" \
    -DTPL_PARMETIS_LIBRARIES="/usr/lib/libparmetis.so" && \
    make -j ${num_jobs} && make install

RUN git clone -b release --single-branch https://gitlab.com/petsc/petsc.git petsc && cd petsc && git checkout v3.20.2
RUN cd petsc && \
    ./configure --with-cc=mpicc --with-cxx=mpicxx --with-fc=mpif90 \
    --with-debugging=0 \
    --with-fortran-bindings=0 \
    --with-sowing=0 \
    --with-blaslapack-dir="/usr/lib/x86_64-linux-gnu" \
    --with-metis-lib="/usr/lib/x86_64-linux-gnu/libmetis.so" \
    --with-metis-include="/usr/include" \
    --with-parmetis-lib="/usr/lib/libparmetis.so" \
    --with-parmetis-include="/usr/include" \
    --with-hypre-dir="/usr/local" \
    --with-superlu_dist-dir="/usr/local" \
    --prefix="/usr/local" && \
    make PETSC_DIR=/opt/archives/petsc PETSC_ARCH=arch-linux-c-opt all && \
    make PETSC_DIR=/opt/archives/petsc PETSC_ARCH=arch-linux-c-opt install

USER euler
WORKDIR /home/euler

COPY --chown=euler:euler user.mk mfem/config/user.mk
# Run config/make s.t. first use is a bit quicker
RUN cd mfem && make config && make -j ${num_jobs} && cd examples && make ex1 && make ex1p