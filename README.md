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

#### ⚙️ `mfem/developer` image

This Docker image is used to provide a containerized environment for development
of MFEM.

It is the image we used in the MFEM [AWS tutorial](https://mfem.org/tutorial) in
August 2022.

You can find the `mfem/developer` source in the [developer](developer/) directory and
the pre-built image at [ghcr.io/mfem/containers/developer](http://ghcr.io/mfem/containers/developer).
