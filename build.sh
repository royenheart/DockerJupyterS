#!/bin/bash
#####################################################################################
# This shell script is to automatically generate the docker image and the running it.
#####################################################################################

## The config of image

version=v4
username=$(whoami)
buildpath=$(pwd)
uid=$(id -u)

## Check for the built environment

if [ "${username}" = "root" ]; then
	printf "Using root to execute server is not safe and not permitted\n"
	exit -1
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

isDJSbuilt=$(docker images | grep "djs" | grep "${version}")

if [ ! -n "${isDJSbuilt}" ]; then
	jupyterConfig=jupyter_notebook_config_extra
	printf "Please set the password of your jupyter server\n"
	read passwd
	printf "Using your name: '${username}' as the image user\n"
	echo c.NotebookApp.ip = "'*'" > ./${jupyterConfig}
    	echo c.NotebookApp.notebook_dir = "'/home/${username}/pythonS'" >> ./${jupyterConfig}
    	echo c.NotebookApp.token = "'${passwd}'" >> ./${jupyterConfig}
	echo c.NotebookApp.terminado_settings = "{'shell_command': 'bash'}" >> ./${jupyterConfig}
	echo "c.NotebookApp.certfile = u'/home/${username}/mycert.pem'" >> ./${jupyterConfig}
	#printf "Using ssl?(y/n)\n"
	#read isSsl
	#if [[ ${isSsl} == "y" ]]; then
		#printf "please insert where your ssl kert locate\n"
		#read sslFile
		#fileName=$(echo ${sslFile} | grep -Po "(?<=/)\w+\.pem")
		#fileSuffix=$(echo ${fileName} | grep -Po "(?<=\.)\w+")
		#if [[ ! -f ${sslFile} ]] || [[ ${fileSuffix} != "pem" ]]; then
			#printf "The path you given hasn't a pem file!\n"
			#exit -1
		#else
			#echo "c.NotebookApp.certfile = u'/home/${fileName}'" >> ./${jupyterConfig}
		#fi
	#fi
	docker build -t djs:${version} \
		--build-arg USER_NAME=${username} \
                --build-arg jupyterConfig=${jupyterConfig} \
		--build-arg uid=${uid} --no-cache .
	if [[ $? != 0 ]]; then
		printf "djs:${version} build failed!\n"
		exit -1
	fi
	printf "djs:${version} has been successfully built\n"
	unset ${passwd}
	rm ./${jupyterConfig}
else
	echo "images has been built, will soon start the Jupyter-Notebook server"
fi

printf "Check if folder ~/pythonS exit, which is to store your project files\n"
if [ ! -d "/home/${username}/pythonS" ]; then
	printf "There is no folder 'pythonS' in your home folder\n"
	printf "Now create one to store your files in Jupyter-Notebook\n"
	mkdir ~/pythonS
else
	printf "Folder 'pythonS' exited in your home folder\n"
fi

## Generate docker jupyter-notebook server running scripts

if [[ -f ./Run.sh ]]; then
	rm -rf ./Run.sh
fi

echo "#!/bin/bash" >> ./Run.sh
echo "docker run -d --name djs -p 7777:8888 -v ~/pythonS:/home/${username}/pythonS djs:${version}" >> ./Run.sh

chmod +x ./Run.sh
