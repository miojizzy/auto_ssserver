#!/bin/bash

# env
mkdir -p /data
cd /data

# golang
wget https://go.dev/dl/go1.23.4.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.bashrc

# outline server
git clone -b v1.7.3 --depth=1 https://github.com/Jigsaw-Code/outline-ss-server.git


# config
echo >/data/outline_server_config.yml <<EOF
services:
  - listeners:
      - type: tcp
        address: "[::]:2333"
      - type: udp
        address: "[::]:2333"
    keys:
        - id: user-0
          cipher: chacha20-ietf-poly1305
          secret: 12345678
  - listeners:
      - type: tcp
        address: "[::]:2334"
      - type: udp
        address: "[::]:2334"
    keys:
        - id: user-1
          cipher: chacha20-ietf-poly1305
          secret: 12345678
EOF

# start
cd outline-ss-server
nohup go run ./cmd/outline-ss-server -config /data/outline_server_config.yml -metrics 0.0.0.0:9091 --replay_history=10000 > /var/log/outline_ssserver.log 2>&1 &


sleep 2

ps auxf | grep server
