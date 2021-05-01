#!/bin/bash

#SS_IP="52.194.71.206"
SS_PORT=2333
SS_PWD="Mioji2018"


apt update
apt install python -y
apt install python-pip -y

pip2 install shadowsocks 


sed -i "s/cleanup/reset/g" /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py

ssserver -p ${SS_PORT} -k ${SS_PWD} -m aes-256-cfb >/tmp/ssserver.log 2>&1 &

sleep 3
ps auxf | grep ssserver | grep -v grep | wc -l


