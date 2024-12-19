#!/usr/bin/python

import sys
import json
from datetime import datetime

if sys.version_info[0] < 3:
    import commands
else:
    import subprocess



# use get_command_output to call shell command
def get_command_output(cmd):
    if sys.version_info[0] < 3:
        return commands.getoutput(cmd)
    else:
        return subprocess.check_output(cmd, shell=True).decode('utf-8')


#### setup config
datestr = datetime.now().strftime("%Y%m%d")
SECURITY_GROUP_NAME = "auto_ss_sg_{}".format(datestr)
LAUNCH_TEMPLATE_NAME = "auto_ss_{}".format(datestr)
# app port
PORT_PSWD_MAP = {
    2333: "12345678",
    2334: "12345678",
}
# infra port
INFRA_PORT = []
METHOD = "aes-256-cfb"


##### format config data
ss_json = {
    "server": "0.0.0.0",
    "timeout": 300,
    "method": METHOD,
    "port_password": PORT_PSWD_MAP
}

user_data = """#!/bin/bash

mkdir /data
cd /data
echo > config.json <EOF
{}
EOF
git clone https://github.com/miojizzy/auto_ssserver.git > git_log 2>&1
cd auto_ssserver && ./setup.sh osi 
touch testfile
""".format(json.dumps(ss_json))



def main():
    generate_ud()
    generate_sg()
    generate_sgi()
    generate_lt()



def generate_sg():
    data = {
        "GroupName": SECURITY_GROUP_NAME,
        "Description": "auto ssserver"
    }
    with open ("conf/sg.json", "w") as f:
        f.write(json.dumps(data)+'\n')
    with open ("conf/dsg.json", "w") as f:
        f.write(json.dumps({"GroupName": SECURITY_GROUP_NAME})+'\n')



def _genSGIData(sg_name, protocol, port):
    return {
        "GroupName": sg_name,
        "IpPermissions":[{
            "FromPort": port, 
            "ToPort": port, 
            "IpProtocol": protocol, 
            "IpRanges": [{"CidrIp": "0.0.0.0/0"}]
        }]
    }

def generate_sgi():
    datas = []
    # for ssh
    datas.append(_genSGIData(SECURITY_GROUP_NAME, "tcp", 22))
    # for ping
    datas.append(_genSGIData(SECURITY_GROUP_NAME, "icmp", -1))
    # for metric
    datas.append(_genSGIData(SECURITY_GROUP_NAME, "tcp", 9091))
    # app
    for port in PORT_PSWD_MAP.keys():
        datas.append(_genSGIData(SECURITY_GROUP_NAME, "tcp", port))
        datas.append(_genSGIData(SECURITY_GROUP_NAME, "udp", port))

    for i in range(len(datas)):
        with open("conf/sgi/sgi%d.json"%(i), "w") as f:
            f.write(json.dumps(datas[i])+'\n')


def generate_ud():
    with open("conf/ud", "w") as f:
        f.write(user_data+'\n')


def generate_lt():
    data = {}
    data["LaunchTemplateName"] = LAUNCH_TEMPLATE_NAME
    data["LaunchTemplateData"] = {
        "EbsOptimized": False,
        "ImageId": "ami-0fe22bffdec36361c",
        "InstanceType": "t2.nano",
        "SecurityGroups": [SECURITY_GROUP_NAME],
        "UserData":get_command_output("cat conf/ud|base64")
    }
    with open("conf/lt.json", "w") as f:                                                        
        f.write(json.dumps(data)+'\n')  
    with open("conf/dlt.json", "w") as f:                                                        
        f.write(json.dumps({"LaunchTemplateName": LAUNCH_TEMPLATE_NAME})+'\n')  



if __name__ == "__main__":
    main()
