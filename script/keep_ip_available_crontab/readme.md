
## crontab example

```bash
# vps auto update
0 19 * * 1-5 cd /root/project/aws_cli/script && sudo sh update2.sh create >>log 2>&1 &
0 9 * * 6-7 cd /root/project/aws_cli/script && sudo sh update2.sh create >>log 2>&1 &
*/5 * * * * cd /root/project/aws_cli/script && sudo sh update2.sh check >>log 2>&1 &
0 2 * * * cd /root/project/aws_cli/script && sudo sh update2.sh terminate >>log 2>&1 &

```
