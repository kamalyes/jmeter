#!/bin/bash
set -e

echo "Starting entrypoint!"
pwd
case $1 in
master)
  tail -f /dev/null # 防止容器启动后退出
  ;;
server)
  $JMETER_HOME/bin/jmeter-server \
    -Dserver.rmi.localport=50000 \
    -Dserver_port=1099
  ;;
*)
  echo "Sorry, this option doesn't exist!"
  ;;
esac

exec "$@"
