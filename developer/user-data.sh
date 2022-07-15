#!/bin/bash
yum update -y
amazon-linux-extras install docker
systemctl start docker
systemctl enable docker
