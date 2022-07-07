#######################################################################
# Dockerfile to build a image that can run jupyterNotebook on port 8888
# Based on Ubuntu
# @Author RoyenHeart 
#######################################################################

#######################
# Stage:build conda env
#######################
FROM ubuntu:latest as BuildConda

## Set args
ARG SHELL=Anaconda3-2021.11-Linux-x86_64.sh
ARG jupyterConfig=jupyter_notebook_config_extra
ARG USER_NAME=djs
ARG uid=1001

## Add user with same uid with the host
RUN useradd -s /bin/bash -u $uid -m $USER_NAME

## Set PATH
ENV PATH $PATH:/home/$USER_NAME/anaconda3/bin

## Set using user and working dir
USER $USER_NAME
WORKDIR /home/$USER_NAME

## copy installation and config file from host
COPY installers/${SHELL} ${jupyterConfig} ./

## install conda
RUN /bin/bash ./$SHELL -b \
    && rm /home/$USER_NAME/$SHELL \
    && conda init bash && exit \
    && conda create --name DJS && conda activate DJS

#####################################
# Stage:build jupyter notebook server
#####################################
FROM ubuntu:latest as BuildJupyter

LABEL author=RoyenHeart

## Set args
ARG USER_NAME=djs
ARG jupyterConfig=jupyter_notebook_config_extra
ARG uid=1001

## Set path
ENV PATH $PATH:/home/$USER_NAME/anaconda3/bin

## Add user
RUN useradd -s /bin/bash -u $uid -m $USER_NAME

## Set user and working dir
USER $USER_NAME
WORKDIR /home/$USER_NAME

## Copy downloaded file from last image
COPY --from=BuildConda /home/$USER_NAME/ /home/$USER_NAME/

## Build jupyter-notebook server
RUN conda install -c conda-forge jupyterlab -y \
    && jupyter-notebook --generate-config \
    && cat /home/$USER_NAME/$jupyterConfig >> ./.jupyter/jupyter_notebook_config.py \
    && rm /home/$USER_NAME/$jupyterConfig

################################################################
## Open jupyter-notebook server when no other services specified
################################################################
CMD ["jupyter-notebook"]
