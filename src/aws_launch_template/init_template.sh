#!/bin/bash

log(){
echo -e "\n"
#echo "************************"
echo "**** "$1
#echo "************************"
}

log "(0/6) make env ..."
rm -rf conf/
mkdir -p conf/sgi

log "(1/6) generate config ..."
python config.py

log "(2/6) delete launch template ..."
aws ec2 delete-launch-template --cli-input-json "`cat conf/dlt.json`"
#log "skip"

log "(3/6) delete security group ..."
aws ec2 delete-security-group --cli-input-json "`cat conf/dsg.json`"
#log "skip"

log "(4/6) create security group ..."
aws ec2 create-security-group --cli-input-json "`cat conf/sg.json`"

log "(5/6) authorize ingress ..."
for ff in `ls conf/sgi`;do
    aws ec2 authorize-security-group-ingress --cli-input-json "$(cat conf/sgi/${ff})"
    continue; 
done

log "(6/6) create launch template ..."
aws ec2 create-launch-template --cli-input-json "`cat conf/lt.json`"

log "finish !"



