#!/bin/bash

./dockerMng/delExitContainer.sh

docker run -d --name djs -p 7777:8888 -v ~/pythonS:/home/royenheart/pythonS djs:v3
