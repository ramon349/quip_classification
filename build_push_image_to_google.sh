#!/bin/bash

source ./common_settings.sh

function build_image() {
   local image_name=$1
   local image_tag=$2
   local docker_file=$3

   docker images |grep ${image_name}

   echo "Build ${image_name}:${image_tag} docker image ..."

   docker build  --force-rm -f ${docker_file} -t ${public_docker_host}/${GOOGLE_PROJECT_ID}/${image_name}:${image_tag} . || { echo "${image_name} docker image build failed" ; exit 1; }
   docker images |grep ${image_name}
  
   docker images
  }

function push_image() {
   local image_name=$1
   local image_tag=$2

   echo "Push ${image_name}:${image_tag}  to google docker container registry"
   echo "docker push ${public_docker_host}/${GOOGLE_PROJECT_ID}/${image_name}:${image_tag}"
   #docker push ${public_docker_host}/${GOOGLE_PROJECT_ID}/${image_name}:${image_tag}
 }

function build_push_image() {
   local image_name=$1
   local image_tag=$2
   local docker_file=$3
   build_image ${image_name} ${image_tag} ${docker_file}
   push_image ${image_name} ${image_tag}
   docker images
}

clear
echo "gcloud auth configure-docker"
gcloud auth configure-docker
echo "Remove ${image_name}:${image_tag}"
docker rmi --force ${image_name}:${image_tag}

echo "Build ${image_name}:${image_tag} docker image ..."
time build_push_image ${image_name} ${image_tag} ${dockerfile}