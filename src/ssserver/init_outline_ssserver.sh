#!/bin/bash

# env
mkdir -p /data
cd /data

# golang
wget https://go.dev/dl/go1.23.4.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.bashrc

# outline server
git clone -b v1.7.3 --depth=1 https://github.com/Jigsaw-Code/outline-ss-server.git


# start
cd outline-ss-server
nohup go run ./cmd/outline-ss-server -config cmd/outline-ss-server/config_example.yml -metrics localhost:9091 --replay_history=10000 > /var/log/outline_ssserver.log 2>&1 &


sleep 2

ps auxf | grep server
