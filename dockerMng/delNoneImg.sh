#!/bin/bash
## This shell script is used to delete the compile-failed images

images=$(docker images | grep "<none>" | awk '//{print $3}')

if [ ! -n "${images}" ]; then
	printf "There aren't compile-failed images\n"
else
	printf "Now going to delete the compile-failed images\n"
	docker rmi ${images}
fi
