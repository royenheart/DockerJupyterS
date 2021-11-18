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

# Set the env

ENV SH_NAME Anaconda3-2021.11-Linux-x86_64.sh
ENV CONDA_GET_URL https://repo.anaconda.com/archive/$SH_NAME
ENV CONDA_FOLDER anaconda3
ENV CONDA_BIN /root/$CONDA_FOLDER/bin
ENV PATH=$PATH:$CONDA_BIN

# Set the workdir

WORKDIR /root

# Make the environment

## Flush and Install necessary softwares in the image
RUN apt update && apt install wget -y

## Get the anaconda download file
RUN wget -q $CONDA_GET_URL

## Download the anaconda and activate the environment
RUN /bin/bash -c "/bin/bash ./$SH_NAME -b \ 
                  && conda init bash && exit \
                  && conda create --name DJS && conda activate DJS"

## Download the jupyter-notebook
RUN /bin/bash -c "conda install -c conda-forge jupyterlab -y \
                  && jupyter-notebook --generate-config"

## Setting the jupyter-nootbook
RUN echo c.NotebookApp.ip = \'*\' >> /root/.jupyter/jupyter_notebook_config.py \
    && echo c.NotebookApp.notebook_dir = \'/root/pythonS\' >> /root/.jupyter/jupyter_notebook_config.py \
    && echo c.NotebookApp.token = \'testing\' >> /root/.jupyter/jupyter_notebook_config.py \
    && mkdir /root/pythonS

## Default use jupyter-nootbook
CMD ["jupyter-notebook","--allow-root"]
