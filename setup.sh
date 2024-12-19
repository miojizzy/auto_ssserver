#!/bin/bash




if [ $1 == "awsl" ]; then
	echo "setup aws-tool ..."
	cd ./src/awsl && ./init.sh;
	echo "finish!"

elif [ $1 == "aws" ]; then
	echo "setup aws-cli..."
	cd ./src/aws && ./init.sh;
	echo "finish!"

elif [ $1 == "launch_template" ]; then
	echo "setup ssserver template..."
	cd ./src/aws_launch_template && ./init_template.sh;
	echo "finish!"

elif [ $1 == "si" ]; then
	echo "setup ssserver instance..."
	cd ./src/ssserver && ./init_instance.sh;
	echo "finish!"

elif [ $1 == "osi" ]; then
	echo "setup outline-ssserver instance..."
	cd ./src/ssserver && ./init_outline_ssserver.sh;
	echo "finish!"

else
	echo "error! not found subcmd! "$1
fi
