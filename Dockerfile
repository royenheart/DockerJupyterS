######################################################################
# Dockerfile to build a image that can run jupyterNotebook on port 8888
# Based on Ubuntu
# @Author RoyenHeart 
#######################################################################

# Set the base image

FROM ubuntu:latest
LABEL author="RoyenHeart"

# Using port

EXPOSE 8888

# Set the arg

ARG USER_NAME=djs
ARG SH_NAME=Anaconda3-2021.11-Linux-x86_64.sh
ARG CONDA_GET_URL=https://repo.anaconda.com/archive/$SH_NAME
ARG CONDA_FOLDER=anaconda3
ARG CONDA_BIN=/home/$USER_NAME/$CONDA_FOLDER/bin

# Set the env

ENV PATH=$PATH:$CONDA_BIN

# Make the environment

## Flush and Install necessary softwares in the image
## Then download the anaconda installation file
## Then add user djs with default bash shell
RUN apt-get update && apt-get install wget -y \ 
    && useradd -s /bin/bash -m $USER_NAME 

## Set the workdir
WORKDIR /home/$USER_NAME

## Switch default user
USER $USER_NAME

## Download the anaconda and activate the environment
RUN wget -q $CONDA_GET_URL \
    && /bin/bash ./$SH_NAME -b \ 
    && conda init bash && exit \
    && conda create --name DJS && conda activate DJS

## Download the jupyter-notebook
## Then sets the config of jupyter-notebook
## Then make the jupyter-notebook's working dir and delte the anaconda installation
RUN conda install -c conda-forge jupyterlab -y \
    && jupyter-notebook --generate-config \
    && echo c.NotebookApp.ip = \'*\' >> ./.jupyter/jupyter_notebook_config.py \
    && echo c.NotebookApp.notebook_dir = \'/home/$USER_NAME/pythonS\' >> ./.jupyter/jupyter_notebook_config.py \
    && echo c.NotebookApp.token = \'testing\' >> ./.jupyter/jupyter_notebook_config.py \
    && mkdir ./pythonS && rm ./$SH_NAME

## Default use jupyter-notebook
CMD ["jupyter-notebook"]
