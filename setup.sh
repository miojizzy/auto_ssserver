#!/bin/bash

if [ $1 == "awsl" ]; then
	echo "setup aws-cli ..."
	cd ./src/aws && ./init.sh
	cd -
	echo "finish!"
	echo "setup aws-tool ..."
	cd ./src/awsl && ./init.sh;
	echo "finish!"
elif [ $1 == "st" ]; then
	echo "setup ssserver template..."
	cd ./src/ssserver && ./init_template.sh;
	echo "finish!"
elif [ $1 == "si" ]; then
	echo "setup ssserver instance..."
	cd ./src/ssserver && ./init_instance.sh;
	echo "finish!"
else
	echo "error! not found subcmd! "$1
fi
