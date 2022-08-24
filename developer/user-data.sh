#!/bin/bash
yum update -y
amazon-linux-extras install docker
systemctl start docker
systemctl enable docker
docker run -p 3000:3000 -p 8000:8000 -p 8080:8080 -p 9090:9090 ghcr.io/jandrej/mfem-developer