#!/bin/bash

# env
apt update

apt install -y python python-pip

python -m pip install shadowsocks 


sed -i "s/cleanup/reset/g" /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py

rm -f /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.pyc

# start
nohup ssserver -c /etc/shadowsocks.json >/tmp/ssserver.log 2>&1 &

sleep 2

ps auxf | grep ssserver
