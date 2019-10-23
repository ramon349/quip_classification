#!/usr/bin/env bash

#################################################################
## Docker image/container common settings
##################################################################
GOOGLE_PROJECT_ID=cloudypipelines

## Notes: public: us.gcr.io   private: gcr.io
public_docker_host=us.gcr.io
image_name=til_segmentation
image_tag=0.1
container_name=til_segmentation
dockerfile=Dockerfile