#!/bin/bash
#####################################################################################
# This shell script is to automatically generate the docker image and the running it.
#####################################################################################

## The config of image

version=v3
username=$(whoami)
buildpath=$(pwd)
uid=$(id -u)

## Check for the built environment

if [ "${username}" = "root" ]; then
	printf "Using root to execute server is not safe and not permitted\n"
	exit
fi

CONDA_SH_NAME=Anaconda3-2021.11-Linux-x86_64.sh
CONDA_GET_URL=https://repo.anaconda.com/archive/${CONDA_SH_NAME}

if [ ! -f "${buildpath}/${CONDA_SH_NAME}" ]; then
	printf "The image needs the conda installation, now download it\n"
	wget ${CONDA_GET_URL}
else
	printf "The conda installation has been downloaded\n"
fi

## Start build

isDJSbuilt=$(docker images | grep "djs")

if [ ! -n "${isDJSbuilt}" ]; then
	jupyterConfig=jupyter_notebook_config_extra
	printf "Please set the password of your jupyter server\n"
	read passwd
	printf "Using your name: '${username}' as the image user\n"
	echo c.NotebookApp.ip = "'*'" > ./${jupyterConfig}
    	echo c.NotebookApp.notebook_dir = "'/home/${username}/pythonS'" >> ./${jupyterConfig}
    	echo c.NotebookApp.token = "'${passwd}'" >> ./${jupyterConfig}
	docker build -t djs:${version} \
		--build-arg USER_NAME=${username} \
                --build-arg jupyterConfig=${jupyterConfig} \
		--build-arg uid=${uid} --no-cache .
	printf "djs:${version} has been successfully built\n"
	unset ${passwd}
	rm ./${jupyterConfig}
else
	echo "images has been built, will soon start the Jupyter-Notebook server"
fi

if [ ! -d "/home/${username}/pythonS" ]; then
	printf "There is no folder 'pythonS' in your home folder\n"
	printf "Now create one to store your files in Jupyter-Notebook\n"
	mkdir ~/pythonS
else
	printf "Folder 'pythonS' exited in your home folder\n"
fi

## Run docker jupyter-notebook server

docker run -d --name djs -p 7777:8888 -v ~/pythonS:/home/${username}/pythonS djs:${version}
