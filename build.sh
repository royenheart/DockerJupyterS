#!/bin/bash
#####################################################################################
# This shell script is to automatically generate the docker image and the running it.
#####################################################################################

username=$(echo ${USER})

if [ "${username}" = "root" ]; then
	printf "Using root to execute server is not safe and not permitted\n"
	exit
fi

isDJSbuilt=$(docker images | grep "djs")
if [ ! -n "$isDJSbuilt" ]; then
	printf "Please set the password of your jupyter server\n"
	read passwd
	sed -i "s/testing/$passwd/" ./Dockerfile
	printf "Using your name as the image user\n"
	docker build -t djs:v2 --build-arg USER_NAME=${username} .
else
	echo "images has been built, will soon exec the jupyterServer"
fi

if [ ! -d "/home/${username}/pythonS" ]; then
	printf "There is no folder 'pythonS' in your home folder\n"
	printf "Now create one to store your files in Jupyter-Notebook"
	mkdir ~/pythonS
else
	printf "Folder 'pythonS' exited in your home folder\n"
fi

# Run docker jupyter-notebook server
docker run -d --name djs -p 7777:8888 -v ~/pythonS:/home/${username}/pythonS djs:v2
