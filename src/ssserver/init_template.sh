#!/bin/bash

log(){
echo -e "\n\n"
#echo "************************"
echo "**** "$1
#echo "************************"
}

log "(1/6) generate config ..."
python config.py

log "(2/6) delete security group ..."
aws ec2 delete-security-group --cli-input-json "`cat conf/dsg.json`"

log "(3/6) delete launch template ..."
aws ec2 delete-launch-template --cli-input-json "`cat conf/dlt.json`"

log "(4/6) create security group ..."
aws ec2 create-security-group --cli-input-json "`cat conf/sg.json`"

log "(5/6) authorize ingress ..."
aws ec2 authorize-security-group-ingress --cli-input-json "`cat conf/sgi.json`"

log "(6/6) create launch template ..."
aws ec2 create-launch-template --cli-input-json "`cat conf/lt.json`"

log "finish !"



