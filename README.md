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

There are currently two main configurations that support CPU or GPU computation.
Both types are available in the following configurations:

- [`cpu`](https://github.com/mfem/containers/pkgs/container/containers%2Fcpu)
    - OpenMPI 4.1.2
    - hypre 2.27

- [`cuda-sm70`](https://github.com/mfem/containers/pkgs/container/containers%2Fcuda-sm70)
    - CUDA toolkit 11.8
    - OpenMPI 4.1.2
    - hypre 2.27

- [`cpu-tpls`](https://github.com/mfem/containers/pkgs/container/containers%2Fcpu-tpls)
    - OpenMPI 4.1.2
    - hypre 2.27.0
    - SuperLU_dist 8.2.1
    - PETSc 3.20.2

- [`cuda-tpls-sm70`](https://github.com/mfem/containers/pkgs/container/containers%2Fcuda-tpls-sm70)
    - CUDA toolkit 11.8
    - OpenMPI 4.1.2
    - hypre 2.27.0
    - AmgX 8.2.1

- [`developer-cpu`](https://github.com/mfem/containers/pkgs/container/containers%2Fdeveloper-cpu)
    - extension of `cpu-tpls` that includes a development environment with VSCode server and GLVis
    - see the MFEM [AWS tutorial](https://mfem.org/tutorial/docker) for details
 
- [`developer-cuda-sm70`](https://github.com/mfem/containers/pkgs/container/containers%2Fdeveloper-cuda-sm70)
    - extension of `cuda-tpls-sm70` that includes a development environment with VSCode server and GLVis
    - see the MFEM [AWS tutorial](https://mfem.org/tutorial/docker) for details

Note that the `cuda` images require the host has the 
[NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) to installed and configured.

Note also that the `cuda` images have MFEM and its third-party libraries configured for
CUDA `sm_70`. You can create your own image that support a different compute capability with
`docker-compose` as follows:
```
git clone git@github.com:mfem/containers.git
cd containers
docker-compose build --build-arg cuda_arch_sm=80 cuda && docker image tag cuda:latest cuda-sm80:latest
docker-compose build --build-arg cuda_arch_sm=80 cuda-tpls && docker image tag cuda-tpls:latest cuda-tpls-sm80:latest
```

We recommond starting the container with:
```
docker run --cap-add=SYS_PTRACE -ti --gpus all ghcr.io/mfem/containers/cuda-tpls-sm70:latest /bin/bash
```
which puts you in the home directory for the `euler` user, enables access to all GPUs, and lets you
explore the broad selection of examples or write your own.
