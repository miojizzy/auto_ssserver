[TOC]


---

# Quick Start

1. Install. Paste these cmds into AWS CloudShell.
```
git clone https://gitee.com/miojizzy/auto_ssserver.git
cd auto_ssserver
./setup.sh awsl
./setup.sh st
```
2. Use. 
- `awsl run auto_ss` -> create a server 
- `awsl desc` -> get instance instanceId and IPv4 
- connect to ssserver with client
- `awsl term ` -> stop server with instanceId




# Setup Tools


## aws-cli

> install AWS-Cli

run `./setup.sh aws` to install.

run `aws configure` to quickly set credentials.

example:
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: json

Find in IAM => Security Credentials => Create Access Key
https://us-east-1.console.aws.amazon.com/iam/home?region=ap-northeast-1#/security_credentials
https://stackoverflow.com/questions/21440709/how-do-i-get-aws-access-key-id-for-amazon



## aws_launch_template

> auto create an instance-launch-template for aws account

*Notices*: Require aws-cli

run `./setup.sh st` 

default template name: auto_ss
default port: 2333,2334
default password: 12345678
default method: aes-256-cfb 




## awsl

> A simple tool to use AWS-Cli with short name (aka awsl),
> on machine installed AWS-Cli orAWS CloudShell

*Notices*: Require aws-cli, an instance-launch-template 

### install 

run `./setup.sh awsl`

### usage(subcmd)

#### desc

> is abbreviated from describe, to list some information of all instance.

- input 
    - (none)

-  output
    - InstanceId
    - Status
    - IPv4 (public)
    - SecurityGroup

#### run

> run instance from a launch-template.

- input 
    - TemplateName 

- output
    - bulabula... (informations about new instance)

#### term

> is abbreviated from terminate, to stop and destroy a instance, and stop billing.

- input
    - InstanceId

- output
    - bulabula... (informations about the instance)

#### help

> can provide all kinds of help except help. :)
    



## ssserver

> to setup shadowsocket server automaticly (pipy version)

### install

run `./setup.sh st`

`./setup.sh si` is for script




## outline_server

> to setup shadowsocket server automaticly (outline vpn version)

### install

run `./setup.sh osi`



-----

# Script Tools

## keep_ip_available_crontab

> crontab script, to create/terminate instance automaticaly, update ip auto


