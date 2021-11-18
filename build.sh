#!/bin/bash
#####################################################################################
# This shell script is to automatically generate the docker image and the running it.
#####################################################################################

isDJSbuilt=$(docker images | grep "djs")
if [ ! -n "$isDJSbuilt" ]; then
	printf "Please set the password of your jupyter server\n"
	read passwd
	sed -i "s/testing/$passwd/" ./Dockerfile
	docker build -t djs:v1 .
else
	echo "images has been built, will soon exec the jupyterServer"
fi

mkdir ~/pythonS

docker run -dit --name djs -p 7777:8888 -v ~/pythonS:/root/pythonS djs:v1
