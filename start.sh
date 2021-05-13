#!/bin/bash

SS_PORT=2333
SS_PWD="Mioji2018"

nohup ssserver -p ${SS_PORT} -k ${SS_PWD} -m aes-256-cfb >/tmp/ssserver.log 2>&1 &
