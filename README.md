## 📦 MFEM Docker Containers

This repository contains [Docker](https://www.docker.com/) images to aid
[MFEM](https://github.com/mfem/mfem) development and the exploration of MFEM and
its capabilities in a variety of computing environments: from personal laptops, to HPC
clusters, and the cloud.

- You can find pre-built images in the right sidebar under `Packages`.

- Instructions how to use these containers locally can be found in the
[Docker page](https://mfem.org/tutorial/docker) of the MFEM website.

- You can also use them to setup your own cloud MFEM development environment.
See this [AWS script](developer/user-data.sh).

There are currently two main configurations that support CPU or GPU computation
(through CUDA preconfigured with SM 70). Both types are available with only
OpenMPI and hypre
([cpu](https://github.com/mfem/containers/pkgs/container/containers%2Fcpu) and
[cuda-sm70](https://github.com/mfem/containers/pkgs/container/containers%2Fcuda-sm70))
or in the following configurations:

- [cpu-tpls](https://github.com/mfem/containers/pkgs/container/containers%2Fcpu-tpls)
    - OpenMPI 4.1.2
    - hypre 2.27.0
    - SuperLU_dist 8.2.1
    - PETSc 3.20.2

- [cuda-tpls-sm70](https://github.com/mfem/containers/pkgs/container/containers%2Fcuda-tpls-sm70)
    - OpenMPI 4.1.2
    - hypre 2.27.0
    - AMGX 8.2.1

If you plan to build your own image to support a different architecture you can
use the predefined build arguments for docker-compose e.g.
```
docker-compose build --build-arg cuda_arch_sm=80 cuda && docker image tag cuda:latest cuda-sm80:latest
docker-compose build --build-arg cuda_arch_sm=80 cuda-tpls && docker image tag cuda-tpls:latest cuda-tpls-sm80:latest
```

The cuda images require the host to be configured with
[NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

We recommond starting the container with
```
docker run --cap-add=SYS_PTRACE -ti --gpus all ghcr.io/mfem/containers/cuda-tpls:latest /bin/bash
```
which puts you in the home directory for the mfem user and let's you explore the
broad selection of examples or write your own.

#### ⚙️ `mfem/developer` image

This Docker image is used to provide a containerized environment for development
of MFEM.

It is the image we used in the MFEM [AWS tutorial](https://mfem.org/tutorial) in
August 2022.

You can find the `mfem/developer` source in the [developer](developer/) directory.

Since December 2023 this image is available in a prebuilt configuration for
either
[CPU](https://github.com/mfem/containers/pkgs/container/containers%2Fdeveloper-cpu)
or
[CUDA](https://github.com/mfem/containers/pkgs/container/containers%2Fdeveloper-cuda-sm70)
including all third party libraries listed above.