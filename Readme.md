[TOC]


---

# Quick Start

1. Install. Print these cmds into AWS CloudShell.
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

# Tools

## awsl

> A simple tool on AWS CloudShell, aka awsl

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
    

---


## ssserver

> to setup shadowsocket server automaticly

### install

run `./setup.sh st`

`./setup.sh si` is for script

*Notice*:All configurations are build in template. 
If you want to change config of ssserver, you need to modify `src/ssserver/config.py` and setup again. 
If you don't know how to edit file, you'd better not to do this.

### usage

After 'setup st', you can use 'awsl' tool to run instance.

default template name: `auto_ss`
default port: 2333
default password: 12345678
default method: aes-256-cfb 


