#!/usr/bin/env bash

#################################################################
## Docker image/container common settings
##################################################################
GOOGLE_PROJECT_ID=cloudypipelines-com
## Notes: public: us.gcr.io   private: gcr.io
public_docker_host=us.gcr.io
image_name=til_segmentation
image_tag=1.4
container_name=til_segmentation
dockerfile=Dockerfile