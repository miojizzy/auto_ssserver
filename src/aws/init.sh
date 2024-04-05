#!/bin/bash


URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

FILE="awscli.zip"

DIR="aws"

[[ ! -f $FILE ]] && wget $URL -O $FILE

[[ ! -d $DIR ]] && unzip $FILE

cd $DIR && sudo ./install
