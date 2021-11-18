#######################################################################
# Dockerfile to build a image that can run jupyterNotebook on port 8888
# Based on Ubuntu
# @Author RoyenHeart 
#######################################################################

# Set the base image

FROM ubuntu:latest

# Set the env

ENV USER_NAME DockerJupyterS
ENV SH_NAME Anaconda3-2021.11-Linux-x86_64.sh
ENV CONDA_GET_URL https://repo.anaconda.com/archive/$SH_NAME
ENV CONDA_FOLDER anaconda3
ENV CONDA_BIN /home/$USER_NAME/$CONDA_FOLDER/bin

# Make the environment

RUN apt update && apt install vim wget -y
RUN useradd -m $USER_NAME --shell /bin/bash && cd /home/$USER_NAME && wget -q $CONDA_GET_URL
RUN chmod +x /home/$USER_NAME/$SH_NAME && chown $USER_NAME:$USER_NAME /home/$USER_NAME/$SH_NAME
RUN /bin/bash -c "su $USER_NAME && cd /home/$USER_NAME && /bin/bash ./$SH_NAME -b -p /home/$USER_NAME/$CONDA_FOLDER \
                  && echo PATH=$PATH:/home/$USER_NAME/$CONDA_FOLDER/bin >> /home/$USER_NAME/.bashrc"
RUN /bin/bash -c "su $USER_NAME && export PATH=$PATH:$CONDA_BIN \ 
                  && conda init bash && exit \
		  && conda create --name DJS && conda activate DJS"; exit 0
RUN /bin/bash -c "su $USER_NAME && export PATH=$PATH:$CONDA_BIN  \ 
                  && conda install -c conda-forge jupyterlab -y \
                  && jupyter-notebook --generate-config \
                  && echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter-notebook-config.py \
                  && echo "c.NotebookApp.notebook_dir = ~/pythonS" >> ~/.jupyter/jupyter-notebook-config.py \
                  && echo "c.NotebookApp.token = 'testing'" >> ~/.jupyter/jupyter-notebook-config.py \
		  && mkdir /home/"
RUN /bin/bash -c "mkdir /home/$USER_NAME/pythonSLog /home/$USER_NAME/pythonS \
                  && chown $USER_NAME:$USER_NAME /home/$USER_NAME/pythonS \
                  && chown $USER_NAME:$USER_NAME /home/$USER_NAME/pythonSLog"
