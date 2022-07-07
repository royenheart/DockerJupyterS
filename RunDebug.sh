#!/bin/bash

./dockerMng/delExitContainer.sh

read user

echo user has been set to ${user}, the default notebook dir is located to ~/${user}/pythonS

docker run -id --name djs -p 7777:8888 -v ~/pythonS:/home/royenheart/pythonS djs:v3 /bin/bash
