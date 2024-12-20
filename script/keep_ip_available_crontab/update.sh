#!/usr/bin/env bash

CONF="./conf"


function DEBUG_LOG(){
    date +"[%Y-%m-%d %H:%M:%S] [DEBUG] $*" >> /dev/null
}
function INFO_LOG(){
    date +"[%Y-%m-%d %H:%M:%S] [INFO] $*" >> ./log
}
function ERROR_LOG(){
    date +"[%Y-%m-%d %H:%M:%S] [ERROR] $*" >> ./log
}



# return: insta_id ip
function GetInstanceInfo() {
    ret=`aws ec2 describe-instances`
    insta_id=`echo $ret|jq "[ .Reservations[] | select(.Instances[0].State.Name == \"running\") ][0].Instances[0].InstanceId" -r`
    ip=`echo $ret|jq "[ .Reservations[] | select(.Instances[0].State.Name == \"running\") ][0].Instances[0].PublicIpAddress" -r`
    [[ $insta_id == "null" ]] && insta_id="";
    [[ $ip == "null" ]] && ip="";
    DEBUG_LOG "insta_id: $insta_id, ip: $ip"
}

# param: insta_id
function ReleaseInstance() {
    if [[ $1 != "" ]]; then
        ret=`aws ec2 terminate-instances --instance-ids ${1}`
    fi
    DEBUG_LOG "Release Instance"
}

# param: template_name 
function AllocateInstance() {
    ret=`aws ec2 run-instances --launch-template LaunchTemplateName=${1} --key-name="ap-northeast-1"`
    DEBUG_LOG "Allocate Instance"
}


# param: insta_id
# return: assoc_id alloc_id ip
function GetAddressInfo() {
    ret=`aws ec2 describe-addresses`
    assoc_id=`echo $ret |jq ".Addresses[]| select(.InstanceId==\"${1}\") | .AssociationId" -r`
    alloc_id=`echo $ret |jq ".Addresses[]| select(.InstanceId==\"${1}\") | .AllocationId" -r`
    ip=`echo $ret |jq ".Addresses[]| select(.InstanceId==\"${1}\") | .PublicIp" -r`
    [[ $assoc_id == "null" ]] && assoc_id="";
    [[ $alloc_id == "null" ]] && alloc_id="";
    [[ $ip == "null" ]] && ip="";
    DEBUG_LOG "assoc_id: $assoc_id, alloc_id: $alloc_id, ip: $ip"
}

# param: assoc_id alloc_id
function ReleaseAddress() {
    if [[ ${1} != "" ]]; then
        ret=`aws ec2 disassociate-address --association-id ${1}`
    fi
    if [[ ${2} != "" ]]; then
        ret=`aws ec2 release-address --allocation-id  ${2}`
    fi
    DEBUG_LOG "Release Address"
}

# param: insta_id
# return: alloc_id ip
function AllocateAddress() {
    ret=`aws ec2 allocate-address`
    alloc_id=`echo $ret| jq ".AllocationId" -r`
    ip=`echo $ret| jq ".PublicIp" -r`
    ret=`aws ec2 associate-address --allocation-id ${alloc_id} --instance-id ${1}`
    DEBUG_LOG "alloc_id: $alloc_id, ip: $ip"
}

# param: ip
# return: loss
function CheckPingLoss() {
    loss=`ping $1 -w 10| grep "packet loss"| awk -F "[ %]" '{print $6}'`
    DEBUG_LOG "loss: $loss"
}

# param: nginx_conf newip
function ChangeNginx() {
    sed -r "s/^( *server ).*(:2333;)$/\1$2\2/g" -i $1
    nginx -s reload
    DEBUG_LOG "restart nginx: conf:$1, new:$2"
}

# param: nginx_conf newip nginx_docker_name
function ChangeNginxDocker() {
    sed -r "s/^( *server ).*(:2333;)$/\1$2\2/g" -i $1
    DEBUG_LOG "restart nginx: conf:$1, new:$2, dk name:$3"
    docker exec -it $3 nginx -s reload 
    DEBUG_LOG "restart nginx: conf:$1, new:$2, dk name:$3"
}



function Create() {
    GetInstanceInfo
    if [[ $insta_id != "" ]];then 
        ERROR_LOG "instance already exist!"
        return
    fi
    AllocateInstance $launch_template_name

    while [[ $insta_id == "" || $ip == "" ]]; do
        sleep 5 
        GetInstanceInfo
    done

    ChangeNginxDocker $nginx_conf $ip "$nginx_docker_name"

    INFO_LOG "Create VPS"
}


function Terminate() {
    GetInstanceInfo
    if [[ $insta_id == "" ]];then 
        ERROR_LOG "no running instance"
        return
    fi
    GetAddressInfo $insta_id
    if [[ $assoc_id != "" || $alloc_id != "" ]];then
        ReleaseAddress $assoc_id $alloc_id
    fi
    ReleaseInstance $insta_id

    INFO_LOG "Terminate VPS"
}

function Check() {
    GetInstanceInfo
    if [[ $insta_id == "" ]];then 
        ERROR_LOG "no running instance"
        return
    fi

    CheckPingLoss $ip
    [[ $loss -lt $loss_max_limit ]] && INFO_LOG "Check Pass: insta:$insta_id, loss:$loss" && return

    old_ip=$ip
    GetAddressInfo $insta_id

    ReleaseAddress $assoc_id $alloc_id

    AllocateAddress $insta_id
    new_ip=$ip

    ChangeNginxDocker $nginx_conf "$new_ip" "$nginx_docker_name"

    INFO_LOG "change ip address: loss:$loss, old:$old_ip, new:$new_ip"
}





alias aws="/usr/local/bin/aws"
PATH=$PATH:/root/bin
source $CONF

case $1 in
    "create")
    Create
    ;;
    "check")
    Check
    ;;
    "terminate")
    Terminate
    ;;
    *)
    ERROR_LOG "error cmd:" $1
    ;;
esac


