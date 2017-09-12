#!/bin/bash


BACKEND_FOLDER="your_backend_folder"
CONTAINER_NAME="your_container_name"
DOCKER_IMAGE_NAME="your_docker_image_name"




cd $BACKEND_FOLDER
echo "pulling your backend git remote"
git pull 

echo "stopping and removing tripopt container and image"
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
docker rmi $DOCKER_IMAGE_NAME

echo "building the new image"
docker build -t $DOCKER_IMAGE_NAME .

echo "running the new container on 54.229.140.217:4000"
docker run -p 4000:4000  -d --name $CONTAINER_NAME $DOCKER_IMAGE_NAME

