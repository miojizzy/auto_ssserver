#!/usr/bin/python
import json
import commands

PORT_PSWD_MAP = {
    2333: "12345678",
    2334: "12345678",
}
METHOD = "aes-256-cfb"
SECURITY_GROUP_NAME = "auto_ss_sg"
LAUNCH_TEMPLATE_NAME = "auto_ss"

ss_json = {
    "server": "0.0.0.0",
    "timeout": 300,
    "method": METHOD,
    "port_password": PORT_PSWD_MAP
}

user_data = """
#!/bin/bash

echo '{}' > /etc/shadowsocks.json

git clone https://github.com/miojizzy/auto_ssserver.git 

cd auto_ssserver && ./setup.sh si

""".format(json.dumps(ss_json))



def main():
    generate_ud()
    generate_sg()
    generate_sgi()
    generate_lt()


def generate_sg():
    data = {
        "Description": "security group for auto ssserver",
        "GroupName": SECURITY_GROUP_NAME
    }
    with open ("conf/sg.json", "w") as f:
        f.write(json.dumps(data)+'\n')
    with open ("conf/dsg.json", "w") as f:
        f.write(json.dumps({"GroupName": SECURITY_GROUP_NAME})+'\n')


def generate_sgi():
    data = {}
    data["GroupName"] = SECURITY_GROUP_NAME
    data["IpPermissions"] = []
    for port,pswd in PORT_PSWD_MAP.items():
        item = {}
        item["FromPort"] = port
        item["ToPort"] = port
        item["IpProtocol"] = 'tcp'
        item["IpRanges"]=[{"CidrIp": "0.0.0.0/0"}]
        data["IpPermissions"].append(item)
    with open("conf/sgi.json", "w") as f:
        f.write(json.dumps(data)+'\n')


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
        "UserData": commands.getoutput("cat conf/ud|base64")
    }
    with open("conf/lt.json", "w") as f:                                                        
        f.write(json.dumps(data)+'\n')  
    with open("conf/dlt.json", "w") as f:                                                        
        f.write(json.dumps({"LaunchTemplateName": LAUNCH_TEMPLATE_NAME})+'\n')  



if __name__ == "__main__":
    main()
