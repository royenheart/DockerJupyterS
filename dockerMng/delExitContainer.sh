#!/bin/bash
## This shell script is used to delete the exited container

containers=$(docker container ls -a | grep "Exited" | awk '//{print $1}')

if [ ! -n ${containers} ]; then
	printf "there aren't exited containers\n"
else
	printf "Now going to delete the exited containers\n"
	docker rm ${containers}
fi
